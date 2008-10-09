class Student < ActiveRecord::Base
  belongs_to :district
  has_many :enrollments
  has_many :schools, :through=>:enrollments
  has_many :comments, :class_name=>"StudentComment"
  has_many :flags do
    def custom_summary
      custom.collect(&:summary)
    end

    def custom
      find_all_by_type('CustomFlag')
    end
    
    def current
      group_by(&:category)
    end
  end

  #This is duplicated in user
  def fullname 
    first_name.to_s + ' ' + last_name.to_s
  end

  def fullname_last_first
    last_name.to_s + ', ' + first_name.to_s
  end



end
