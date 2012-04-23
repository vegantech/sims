# == Schema Information
# Schema version: 20101101011500
#
# Table name: special_user_groups
#
#  id           :integer(4)      not null, primary key
#  user_id      :integer(4)
#  district_id  :integer(4)
#  school_id    :integer(4)
#  grouptype    :integer(4)
#  grade        :string(255)
#  is_principal :boolean(1)
#  created_at   :datetime
#  updated_at   :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SpecialUserGroup do
  describe 'autoassign user assignments' do
    it 'should autoassign a user assignment when a user was previously assigned to another school' do #657
      UserSchoolAssignment.delete_all
      SpecialUserGroup.delete_all
      user = Factory(:user, :district_id => 1)
      user.user_school_assignments.create!(:school_id => 2)
      user.special_user_groups.create!(:school_id => 1,  :grouptype=>3)
      user.special_user_groups.create!(:school_id => 1,  :grouptype=>3, :grade=>'02')
      UserSchoolAssignment.count.should == 1
      SpecialUserGroup.autoassign_user_school_assignments
      UserSchoolAssignment.count.should == 2
      UserSchoolAssignment.first.school_id.should == 2
      UserSchoolAssignment.last.school_id.should == 1
      UserSchoolAssignment.first.user_id.should == user.id
      UserSchoolAssignment.last.user_id.should == user.id
    end
  end
end
