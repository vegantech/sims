# == Schema Information
# Schema version: 20101101011500
#
# Table name: enrollments
#
#  id         :integer(4)      not null, primary key
#  school_id  :integer(4)
#  student_id :integer(4)
#  grade      :string(16)
#  created_at :datetime
#  updated_at :datetime
#  end_year   :integer(4)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Enrollment do
end


