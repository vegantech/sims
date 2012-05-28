class StudentSearch


  #This allows me to use it in url_for as a singleton resource
  def self.model_name
    ActiveModel::Name.new(StudentSearch).tap{|s|
      s.instance_variable_set :@singular, "student_searches"
      s.instance_variable_set :@plural, "student_search"
    }
  end

  #singleton resource, no param
  def to_param
    nil
  end
end
