# == Schema Information
# Schema version: 20101101011500
#
# Table name: student_comments
#
#  id         :integer(4)      not null, primary key
#  student_id :integer(4)
#  user_id    :integer(4)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StudentComment do
  subject { StudentComment.new }
  it { should have(1).error_on(:body) }

  describe 'with an asset' do
    subject { StudentComment.new.tap{ |sc| sc.assets.build } }
    it { should have(:no).errors_on(:body) }
  end

end
