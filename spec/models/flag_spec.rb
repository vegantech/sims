# == Schema Information
# Schema version: 20090325221606
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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Flag do
  describe 'current' do
    it 'should system + custom - ignored flags' do
      Flag.delete_all
      s1=SystemFlag.create!(:category => 'math', :reason => "Can't add")
      s2=SystemFlag.create!(:category => 'attendance', :reason => "doesn't show up")
      i1=IgnoreFlag.create!(:category => 'languagearts', :reason => 'Speaks 50 languages, just not English')
      i2=IgnoreFlag.create!(:category => 'math', :reason => 'Delete me later')
     
      Flag.current['attendance'].should include(s2)
      Flag.current['math'].should be_nil
      Flag.current['language_arts'].should be_nil

      c1 = CustomFlag.create!(:category => 'attendance', :reason => 'Never leaves.')
      c2 = CustomFlag.create!(:category => 'suspension', :reason => "Evil")

      Flag.current['attendance'].should include(c1)
      Flag.current['attendance'].should include(s2)
      Flag.current['suspension'].should include(c2)

    end

    it 'should work when scoped' do
      student=Factory(:student)
      student.ignore_flags << IgnoreFlag.new(:category => 'math', :reason => '2 + 2 = 5')
      student.flags.current.should == []
    end
  end
end
