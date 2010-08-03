module DeepClone
  def deep_clone(target_parent)
    k=self.class.find_with_destroyed(:first,:conditions=>{:copied_from=>id, deep_clone_parent_field => target_parent.id})
    if k
      # it already exists
    else
      k=clone
      k.send("#{deep_clone_parent_field}=",target_parent.id)
      k.copied_at=Time.now
      k.copied_from = id
      k.save! if k.valid? and k.deep_clone?
    end
    deep_clone_children.each do |child|
      k.send(child) << self.send(child).collect{|o| o.deep_clone(k)}
    end
    k
  end

  def deep_clone?
    true
  end


  private
  def deep_clone_parent_field
    raise "This must be implemented and be a string"
  end


  def deep_clone_children
    raise "This must be an array of strings.  "
  end
end
