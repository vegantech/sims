# == Schema Information
# Schema version: 20090118224504
#
# Table name: flags
#
#  id          :integer         not null, primary key
#  category    :string(255)
#  user_id     :integer
#  district_id :integer
#  student_id  :integer
#  reason      :text
#  type        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class CustomFlag < Flag
  validate :either_custom_or_ignore

  def either_custom_or_ignore
    if IgnoreFlag.find_by_category_and_student_id(category, student_id)
      errors.add(:category, "Remove custom flag first.")
    end
  end
end