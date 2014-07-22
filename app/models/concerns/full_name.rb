module FullName
  extend ActiveSupport::Concern

  included do
    validates :first_name, :last_name, presence: true
  end

  module ClassMethods
    def find_by_fullname(fullname)
      #this fails if the middle name is excluded from the search
      find(:first, conditions: "concat(first_name,' ', if(coalesce(middle_name,'') !='' , concat(left(middle_name,1),'. '),'') , last_name) = \"#{fullname}\"")
    end
  end

  def fullname
    [first_name, middle_initial, last_name, stripped_suffix].compact.join(' ')
  end

  def fullname_last_first
    last_name.to_s + ', ' + [first_name, middle_initial, stripped_suffix].compact.join(' ')
  end

  def middle_initial
    "#{middle_name.first}." if defined?(middle_name) && middle_name.present?
  end

  def stripped_suffix
    suffix.sub(/\.$/, '') if defined?(suffix) && suffix.present?
  end

  def to_s
    fullname
  end
end
