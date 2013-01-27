class ActiveRecord::Errors
  #a suggested fix from http://stackoverflow.com/questions/2067945/issues-with-displaying-validation-messages-with-nested-forms-rails-2-3
  def errors_hash
    return @errors
  end
end

ActiveRecord::Base.class_eval do
  def validate_uniqueness_of_in_memory(collection, attrs, message)
    hashes = collection.inject({}) do |hash, record|
      key = attrs.map {|a| record.send(a).to_s }.join
      if key.blank? || record.marked_for_destruction?
        key = record.object_id
      end
      unless hash[key]
        hash[key] = record
      else
        attrs.each{|a| record.errors.add(a,"Duplicate")}
      end
      hash
    end
    if collection.length > hashes.length
      self.errors.add(:base,message)
    end
  end
end
