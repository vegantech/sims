# == Schema Information
# Schema version: 20101101011500
#
# Table name: ext_arbitraries
#
#  id         :integer(4)      not null, primary key
#  student_id :integer(4)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

class ExtArbitrary < ActiveRecord::Base
  belongs_to :student

  def to_s
    content
  end
end
