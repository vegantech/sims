# == Schema Information
# Schema version: 20101101011500
#
# Table name: users
#
#  id               :integer(4)      not null, primary key
#  username         :string(255)
#  passwordhash     :binary
#  first_name       :string(255)
#  last_name        :string(255)
#  district_id      :integer(4)
#  created_at       :datetime
#  updated_at       :datetime
#  email            :string(255)
#  middle_name      :string(255)
#  suffix           :string(255)
#  salt             :string(255)     default("")
#  district_user_id :string(255)
#  token            :string(255)
#  roles_mask       :integer(4)      default(0)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:all) do
    System.send(:remove_const, 'HASH_KEY') if System.const_defined? 'HASH_KEY'
    System::HASH_KEY=nil
    User.destroy_all
    @user = Factory(:user, :username => "oneschool")
    @school = Factory(:school, :district => @user.district)
  end

  it 'should include FullName' do
    User.included_modules.should include(FullName)
  end

  it 'should have a middle_name' do
    Factory(:user, :middle_name => 'Edward').middle_name.should == 'Edward'
  end

  describe 'full_name' do
    u=User.new(:first_name=>"0First.", :last_name=>"noschools")
    u.fullname.should == ("0First. noschools")
    u.to_s.should == ("0First. noschools")
  end

  describe 'authorized_groups_for_school' do
    it 'should return school groups when user is a member of all groups in school' do
      u=User.new
      s=mock_school(:groups=>"THEE GROUPS HERE")

      u.stub_association!(:special_user_groups,:all_students_in_school? =>true )
      u.authorized_groups_for_school(s).should == s.groups
    end

    it 'should call groups.by_school when user is not a member of all groups in school' do
      u=User.new
      s=mock_school
      u.stub_association!(:special_user_groups,:all_students_in_school? =>false )
      u.stub_association!(:groups,:by_school => "GROUPS BY SCHOOL" )
      u.authorized_groups_for_school(s).should ==  "GROUPS BY SCHOOL"


    end
  end

  describe 'filtered_groups_by_school' do
    it 'should return all authorized_groups for school if prompt is blank' do
      @user.should_receive(:cached_authorized_groups_for_school).with(@mock_school,nil).any_number_of_times.and_return(['group 2', 'group 1'])
      @user.filtered_groups_by_school(@mock_school).should == ['group 2', 'group 1']
    end

    it 'should return one authorized group ' do
      @user.should_receive(:cached_authorized_groups_for_school).with(@mock_school,nil).any_number_of_times.and_return(['group 1'])
      @user.filtered_groups_by_school(@mock_school).should == ['group 1']
    end

    it 'should filter groups if prompt' do
      s=Factory(:school)
      @user.filtered_groups_by_school(s,:grade=>'E',:user=>5 ).should == []
    end
  end

  describe 'filtered_members_by_school' do
    it 'should return all authorized_members' do
      s=Factory(:school)
      g1 = Factory(:group, :school=>s)
      g2 = Factory(:group, :school=>s)
      user = Factory(:user, :groups => [g1,g2])
      user2 = Factory(:user ,:groups => [g1])
      user3 = Factory(:user, :groups => [g2])
      user.filtered_members_by_school(s).should == [user,user2, user3]
    end


  end

  describe 'authorized_ for' do
    it 'should return false if unknown controller' do
      User.new().authorized_for?('this_does_not_exist_at_all').should == false
    end

    it 'should call check true' do
      Role.should_receive(:has_controller?).with('test_controller',[]).and_return(true)
      u=Factory(:user)
      u.authorized_for?('test_controller').should == true
    end

    it 'should call check false' do
      Role.should_receive(:has_controller?).with('test_controller',[]).and_return(false)
      u=Factory(:user)
      u.authorized_for?('test_controller').should == false
    end
  end

  describe "principal?" do
    it 'should return true if principal of a group or special user group and false if not' do
      u=@user
      u.principal?.should == false
      u.user_group_assignments.create!(:is_principal=>true, :group=>Group.new)
      u.principal?.should == true
      u.user_group_assignments.clear
      u.principal?.should == false
    end
  end

  describe 'grouped_principal_overrides' do
    it 'should group requests, responses and pending' do
      @user = Factory(:user)
      @user.grouped_principal_overrides.should == {:user_requests => []}
      req='New Override Request'
      @user.stub!(:principal_override_requests=> [req])
      @user.grouped_principal_overrides.should == {:user_requests => [req]}

      @user.stub!(:principal? => true)
      @user.stub!(:principal_override_responses => ["Principal Override Response"])
      PrincipalOverride.should_receive(:pending_for_principal).with(@user).and_return(["Pending For Principal"])
      @user.grouped_principal_overrides.should == {:user_requests => [req], :principal_responses => ["Principal Override Response"],
          :pending_requests => ["Pending For Principal"]}
    end
  end

  describe 'schools' do
    it 'should return blank for user with no schools' do
      @user.update_attribute(:all_students, false)
      @user.update_attribute(:all_schools, false)
      puts @user.schools
      @user.schools.should be_blank
    end

    it 'should return all schools for user with access to all schools' do
      @user.district.schools.delete_all
      s1=Factory(:school, :district => @user.district)
      s2=Factory(:school, :district => @user.district)
      s3=Factory(:school, :district => @user.district)
      s4=Factory(:school)
      @user.update_attribute(:all_students, true)
      @user.schools.should =~ [s1,s2,s3]
    end

    it 'should return s1 and s3 for user with access to s1 and special access tp s3' do
      @user.update_attribute(:all_students, false)
      s1=Factory(:school, :district => @user.district, :name => "A")
      s2=Factory(:school, :district => @user.district, :name => "B")
      s3=Factory(:school, :district => @user.district, :name => "C")

      @user.user_school_assignments.create!(:school => s1)
      @user.special_user_groups.create!( :school => s3)
      @user.schools.should == [s1,s3]
    end
  end



  describe 'students for school' do
    before :all do
      @authorized_students_user = Factory(:user, :username => "oneschool")
      @other_district = Factory(:student)
      @oneschool_elementary = Factory(:school, :district => @authorized_students_user.district)
      @other_elementary = Factory(:school, :district => @authorized_students_user.district)
      @oneschool_red_6 = Factory(:student, :district => @authorized_students_user.district)
      @oneschool_red_6.enrollments.create!(:grade=>6, :school => @oneschool_elementary)
      @oneschool_red_5 = Factory(:student, :district => @authorized_students_user.district)
      @oneschool_red_5.enrollments.create!(:grade=>5, :school => @oneschool_elementary)
      @other_elementary_6 = Factory(:student, :district => @authorized_students_user.district)
      @other_elementary_6.enrollments.create!(:grade=>6, :school => @other_elementary)
      @red_team=@oneschool_elementary.groups.create(:title => 'red')
      @red_team.students << [@oneschool_red_6,@oneschool_red_5]
      @all_students_in_district = Factory(:user, :district => @authorized_students_user.district, :all_students => true)
      @all_students_in_school = Factory(:user,  :district => @authorized_students_user.district)
      @all_students_in_school.special_user_groups.create!(:school => @oneschool_elementary)
      @all_students_in_grade_6 =  Factory(:user,  :district => @authorized_students_user.district)
      @all_students_in_grade_6.special_user_groups.create!(:school => @oneschool_elementary, :grade => 6)

    end


    it 'should return an empty array when user has access to no students' do
      @authorized_students_user.students_for_school(@oneschool_elementary).should == []
    end

    it 'should return all students in school when user has access to all students in district' do
      @all_students_in_district.students_for_school(@oneschool_elementary).should =~ @oneschool_elementary.students
    end

    it 'should return all students in a school when user has access to all students in school' do
      @all_students_in_school.students_for_school(@oneschool_elementary).should =~ @oneschool_elementary.students
    end

    it 'should return all students in a school of a certain grade when user has access to all students in school for that grade' do
      @all_students_in_grade_6.students_for_school(@oneschool_elementary).should =~ @oneschool_elementary.students.where("enrollments.grade = 6")
    end

    it 'should return all students in a group that a user belongs to' do
      @authorized_students_user.groups.clear
      @authorized_students_user.groups << @red_team
      @authorized_students_user.students_for_school(@oneschool_elementary).should =~ @red_team.students
    end
  end

  describe 'roles' do
    it 'should test roles'
    it 'should assign the role when added with +=' do
      #also tests =
      u=User.new
      u.roles_mask.should == 0
      u.roles += [Role::ROLES.first]
      u.roles_mask.should == 1
    end


    it 'should assign the role when appended with <<' do
      u=Factory(:user)
      u.roles_mask.should == 0
      expect {
      u.roles << Role::ROLES.first
      }.to raise_error(NoMethodError)
#      u.roles_mask.should == 1   warning for now


    end

  end

  describe 'remove from district' do

    def check_user user
      user.reload
      user.district_id.should be_nil
      user.passwordhash.should == 'disabled'
      user.roles.should == []
      user.groups.should == []
      user.schools.should == []
      user.school_teams.should == []
      user.staff_assignments.should == []
      user.email.should be_blank
    end
    it 'should remove a user from a district and clear out noncontent settings' do
      user = Factory(:user, :username=>'user1', :email=>'woo')
      user.remove_from_district
      check_user user
   end
    it 'should remove users in a list of ids form the district and clear out concontent settings' do
      user1 = Factory(:user, :username=>'user1', :email=>'woo')
      user2 = Factory(:user, :username=>'user2', :email=>'woo2')
      User.remove_from_district( [user1.id, user2.id])
      check_user user1
      check_user user2
    end


  end

   describe 'setting user_school_assignments' do
     before :each do
       @user=Factory(:user)
       @e1=@user.user_school_assignments.create!(:school_id=>'1',:admin=>false)
       @e2=@user.user_school_assignments.create!(:school_id=>'2',:admin=>true)
     end

     it 'should not change existing ones when there are none' do
       @user.update_attribute('user_school_assignments_attributes',[])
       @user.user_school_assignments.should == [@e1,@e2]
     end

     it 'should not removeexisting ones' do
       @user.update_attribute('user_school_assignments_attributes',[{:id => @e1.id, :_destroy => 1},{:id => @e2.id, :_destroy => '1'} ])
       @user.user_school_assignments.should be_empty
     end

     it 'should change existing ones when there are none' do
       @user.update_attributes('user_school_assignments_attributes'=>{:id=>@e1.id.to_s,:school_id=>'3'})
       @e1.reload.school_id.should == 3
       @user.user_school_assignments.should ==[@e1,@e2]
     end

     it 'should not validate when changing existing to match' do
       @user.update_attributes('user_school_assignments_attributes'=>[{:id => @e1.id.to_s,:school_id=>'2',:admin=>true}, {:id => @e2.id.to_s,:school_id=>'2'}])
       @user.should_not be_valid
       @user.user_school_assignments.first.errors_on(:admin).should_not be_nil
       @user.user_school_assignments.first.errors_on(:school_id).should_not be_nil
       @user.user_school_assignments.last.errors_on(:admin).should_not be_nil
       @user.user_school_assignments.last.errors_on(:school_id).should_not be_nil
     end

     it 'should add new user_school_assignment' do
       @user.update_attributes('user_school_assignments_attributes'=>[{:school_id=>1, :admin=>true}]).should be_true
       @user.user_school_assignments.find_by_school_id_and_admin(1,true).should_not be_nil
       @user.user_school_assignments[0..1].should == [@e1,@e2]
     end

     it 'should not new user_school_assignment that matches existing ' do
       @user.update_attributes('user_school_assignments_attributes'=>[{:school_id=>'1', :admin=>false}]).should be_false
       @user.should_not be_valid
     end

     it 'should not new user_school_assignment that matches changed existing ' do
       @user.update_attributes({'user_school_assignments_attributes'=>[{:school_id=>1, :admin=>true},
                              {:id => @e1.id.to_s,:admin=>true}]}
                             ).should be_false
       @user.should_not be_valid
     end


     it 'should not new user_school_assignment that matches itself' do
       @user.update_attributes('user_school_assignments_attributes'=>
                              [{:school_id=>'3', :admin=>false},{:school_id=>'3', :admin=>false}]).should be_false
       @user.should_not be_valid
     end


   end

   describe 'staff_assignment' do
     before do
       @u=Factory(:user)
       @s1=Factory(:school, :district_id => @u.district_id)
       @s2=Factory(:school, :district_id => @u.district_id)
       @s3=Factory(:school, :district_id => @u.district_id)
     end
     it 'should add a staff assignment' do
       @u.staff_assignments_attributes = [{:school_id => @s1.id}]
       @u.save
       @u.staff_assignments.count.should == 1
       @u.staff_assignments.first.school_id.should == @s1.id

     end
     it 'should remove a staff assignment' do
       sa=@u.staff_assignments.create!(:school_id => @s1.id)
       @u.staff_assignments_attributes =[{:id =>sa.id, :_destroy => true}]
       @u.save
       @u.staff_assignments.reload.should be_empty
     end
     it 'should add and delete the same staff_assignment' do
       sa=@u.staff_assignments.create!(:school_id => @s1.id)
       @u.staff_assignments_attributes =[{:id =>sa.id, :_destroy => true}, {:school_id => @s1.id}]
       @u.save
       @u.staff_assignments.count.should == 1
       @u.staff_assignments.first.school_id.should == @s1.id
     end
     it 'should remove new assignments when they already exist' do
       sa=@u.staff_assignments.create!(:school_id => @s1.id)
       @u.staff_assignments_attributes =[{:school_id => @s1.id}]
       @u.save
       @u.staff_assignments.count.should == 1
       @u.staff_assignments.first.school_id.should == @s1.id
     end

     it 'should add only 1 new staff assignment when new ones are duplicated' do
       @u.staff_assignments_attributes =[{:school_id => @s1.id},{:school_id => @s1.id}]
       @u.save
       @u.staff_assignments.count.should == 1
       @u.staff_assignments.first.school_id.should == @s1.id
     end

   end

   describe 'admin_of_school?' do
     let(:school) {Factory(:school)}
     let(:user) {Factory(:user)}

     it 'should return true if the user is an admin of the school' do
       user.user_school_assignments.create!(:school => school, :admin => true)
       user.admin_of_school?(school).should be_true
     end

     it 'should return false if the user is not an admin of the school' do
       user.user_school_assignments.create!(:school => school, :admin => false)
       user.admin_of_school?(school).should be_false
     end
   end

   describe 'devise additions' do
     describe 'find_first_by_auth_conditions' do
       it 'should add the district key when not using the reset token'
       it 'should not add the district key when using the reset token'
     end

     describe 'send_reset_password_isnstructions' do
       it 'should add an error when the email is blank'
       it 'should add an error when the district does not support password recovery'
       it 'should test use_key?'
       it 'should work normally'
     end

     describe 'new_with_session' do
       it 'it should get info from googleapps'
     end
   end

   describe 'custom_interventions_enabled?' do
     subject do
       User.new(:district => district, :roles=>[role])
     end
     let(:district){ District.new(:custom_interventions => custom_intervention)}
     let(:role) {}
     let(:custom_intervention) {}

     describe 'disabled' do
       let(:custom_intervention){'disabled'}
       its(:custom_interventions_enabled?) {should == false}

       describe 'content_admin' do
         let(:role) {"content_admin"}
         its(:custom_interventions_enabled?) {should == false}
       end
     end

     describe 'content_admins' do
       let(:custom_intervention){'content_admins'}
       its(:custom_interventions_enabled?) {should == false}

       describe 'content_admin' do
         let(:role) {"content_admin"}
         its(:custom_interventions_enabled?) {should == true}
       end
     end

     describe 'one_off' do
       let(:custom_intervention){'one_off'}
       its(:custom_interventions_enabled?) {should == true}

       describe 'content_admin' do
         let(:role) {"content_admin"}
         its(:custom_interventions_enabled?) {should == true}
       end
     end


     describe 'enabled' do
       let(:custom_intervention){''}
       its(:custom_interventions_enabled?) {should == true}

       describe 'content_admin' do
         let(:role) {"content_admin"}
         its(:custom_interventions_enabled?) {should == true}
       end
     end
   end
end
