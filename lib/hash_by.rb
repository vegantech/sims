module Enumerable
  def hash_by (key, value=nil, opts={})
    self.inject({}) do |hsh, obj|
      if value.nil?
        val = obj
      else
        val=obj[value]
      end

      if opts[:to_i]
        val=val.to_i
        key=key.to_i
      end

      hsh[obj[key]] = val
      hsh
    end
  end
end
 
