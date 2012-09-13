class StudentSearch


  #This allows me to use it in url_for as a singleton resource
  def self.model_name
    ActiveModel::Name.new(StudentSearch).tap{|s|
      def s.route_key
        "student_search"
      end
    }
  end

  #singleton resource, no param
  def to_param
    nil
  end
end
