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
    @mock_school = mock_school(:id => 123)
  end

  describe 'authenticate' do
    it 'should find user with valid login and password' do
      u = User.authenticate('oneschool', 'oneschool')
      u.username.should == 'oneschool'
    end

    it 'should not allow bad password' do
      User.authenticate('oneschool', 'badpass').should be_nil
    end

    it 'should not allow bad login' do
      User.authenticate('doesnotexist', 'ignored').should be_nil
    end

    describe 'additional hash keys and salts' do
      before :all do
        System.send(:remove_const, 'HASH_KEY') if System.const_defined? 'HASH_KEY'
        System::HASH_KEY='mms'
      end

      describe 'allowed_password_hashes' do
        it 'should cover all possibilities'  do
          district = Factory(:district, :key => dk='ddd_kk', :previous_key => next_dk = 'eee_ll')
          salt = 'Salt'
          u = Factory(:user, :district => district, :salt => salt)
          password='zow#3vVc'.downcase

          pnn = Digest::SHA1.hexdigest("#{password}#{salt}")
          pns = Digest::SHA1.hexdigest("#{System::HASH_KEY}#{password}#{salt}")
          ppn = Digest::SHA1.hexdigest("#{password}#{next_dk}#{salt}")
          pps = Digest::SHA1.hexdigest("#{System::HASH_KEY}#{password}#{next_dk}#{salt}")
          pdn = Digest::SHA1.hexdigest("#{password}#{dk}#{salt}")
          pds = Digest::SHA1.hexdigest("#{System::HASH_KEY}#{password}#{dk}#{salt}")

          u.allowed_password_hashes(password).should == [pnn, pns, pdn, pds, ppn, pps]
        end
      end

      it 'should call allowed passwordhashes' do
        @user.should_receive(:allowed_password_hashes).with('fail').and_return([])
        User.should_receive(:find_by_username).with('oneschool').and_return(@user)
        # User.any_instance.should_receive(:allowed_password_hashes).with('fail')
        User.authenticate('oneschool','fail')

      end


      it 'should store new users passwords including system hash_key when present' do
        u = Factory(:user, :password => 'test')
        u.passwordhash.should == User.encrypted_password("#{System::HASH_KEY}test", u.salt, nil, nil)
      end

      it 'should generate a salt when a user sets a password' do
        d = Factory(:district, :key => 'DisKye')
        u = Factory(:user, :password => 'motest', :district => d)
        u.salt.should_not be_blank
      end

      it 'should generate different salts for 2 different users' do
        u1 = Factory(:user)
        u2 = Factory(:user)
        u1.salt.should_not == u2.salt
      end

      it 'should change the salt when a password is changed on an existing record if a different salt has not been passed in' do
        u1 = Factory(:user)
        oldsalt = u1.salt

        u1.password='SOEMWEWEE'
        u1.salt.should_not == oldsalt
      end

      it 'should not change the salt when a password is changed at the same time a salt is explicitly passed in' do
        u1 = Factory(:user)
        oldsalt = u1.salt

        u1.update_attributes(:password => 'SOEMWEWEE', :salt => 'my_new_Salty_Salt_2')
        u1.salt.should == 'my_new_Salty_Salt_2'
      end

      it 'should use the generated salt, system key, and district key' do
        d = Factory(:district, :key => 'DisKye')

        u = Factory(:user, :district => d)
        u.password = 'motest'
        u.password_confirmation = 'motest'
        u.save!
        u.passwordhash.should == Digest::SHA1.hexdigest("#{System::HASH_KEY}motestDisKye#{u.salt}")
      end

    end
  end

  describe 'encrypted_password' do
    it 'should create a hash with a nil system key and district key and salt' do
      pending
      # User.encrypted_password('e')

      # set up user1 with password the old way
      # verify user1 password works

      # set new user2 up with new way
      # verify new password for user2 works

      # verify user1 password still works
    end

  end


  describe 'passwordhash' do
    it 'should be stored encrypted' do

      System.send(:remove_const, 'HASH_KEY') if System.const_defined? 'HASH_KEY'
      System::HASH_KEY=nil

      @user.passwordhash.should == User.encrypted_password('oneschool', @user.salt, nil, nil)
    end
  end

  describe 'password=' do
    it 'should change the password hash when not blank' do
      u=User.new(:password=>"DOG")
      u.passwordhash.should_not be_blank
      p=u.passwordhash
      u.password=""
      u.passwordhash.should == p
    end
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
      @user.should_receive(:authorized_groups_for_school).with(@mock_school,nil).any_number_of_times.and_return(['group 2', 'group 1'])
      @user.filtered_groups_by_school(@mock_school).should == ['group 2', 'group 1']
    end

    it 'should return one authorized group ' do
      @user.should_receive(:authorized_groups_for_school).with(@mock_school,nil).any_number_of_times.and_return(['group 1'])
      @user.filtered_groups_by_school(@mock_school).should == ['group 1']
    end

    it 'should filter groups if prompt' do
      s=Factory(:school)
      @user.filtered_groups_by_school(s,:grade=>'E',:user=>5 ).should == []
    end
  end

  describe 'filtered_members_by_school' do
    it 'should return all authorized_members' do
      @user.stub_association!(:authorized_groups_for_school, :members => ["Zebra", "Elephant", "Tiger"])
      @user.filtered_members_by_school('s1').should == ['Zebra','Elephant', 'Tiger']
    end

    it 'should return one authorized group' do
      @user.stub_association!(:authorized_groups_for_school, :members => ["Zebra"])
      @user.filtered_members_by_school('s1').should == ['Zebra']
    end

    it 'should filter groups if prompt' do
      s=Factory(:school)
      @user.filtered_members_by_school(s,:grade=>'E').should == []
    end
  end

  describe 'authorized_ for' do
    it 'should return false if unknown action_group_type' do
      User.new().authorized_for?('','unknown_group_not_write_or_read').should == false
    end

    it 'should call check for read rights when group is read' do
      Role.should_receive(:has_controller_and_action_group?).with('test_controller','read',[]).and_return(true)
      u=Factory(:user)
      u.authorized_for?('test_controller','read').should == true
    end

    it 'should call check for write rights when group is write' do
      Role.should_receive(:has_controller_and_action_group?).with('test_controller','write',[]).and_return(true)
      u=Factory(:user)
      u.authorized_for?('test_controller','write').should == true
    end
  end

  describe "principal?" do
    it 'should return true if principal of a group or special user group and false if not' do
      u=@user
      u.principal?.should == false
      u.user_group_assignments.create!(:is_principal=>true, :group_id=>11)
      u.principal?.should == true
      u.user_group_assignments.clear
      u.principal?.should == false
      u.special_user_groups.create!(:is_principal => true ,:grouptype=>2, :district_id => 11)
      u.principal?.should == true
    end
  end

  describe 'grouped_principal_overrides' do
    it 'should group requests, responses and pending' do
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

  describe 'authorized_schools' do
    it 'should return blank for user with no schools' do
      @user.authorized_schools.should be_blank
      @user.authorized_schools('zzz').should be_blank
    end

    it 'should return all schools for user with access to all schools' do
      @user.district.schools.delete_all
      s1=Factory(:school, :district => @user.district)
      s2=Factory(:school, :district => @user.district)
      s3=Factory(:school, :district => @user.district)
      s4=Factory(:school)
      @user.special_user_groups.create!(:grouptype => SpecialUserGroup::ALL_STUDENTS_IN_DISTRICT, :district => @user.district)
      @user.authorized_schools.should == [s1,s2,s3]
      @user.authorized_schools(s1.id).should == [s1]
      @user.authorized_schools('qqq').should == []
    end

    it 'should return s1 and s3 for user with access to s1 and special access tp s3' do
      s1=Factory(:school, :district => @user.district)
      s2=Factory(:school, :district => @user.district)
      s3=Factory(:school, :district => @user.district)

      @user.schools << s1
      @user.special_user_groups.create!(:grouptype => SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL, :school => s3, :district => @user.district)
      @user.authorized_schools.should == [s1,s3]
      @user.authorized_schools(s1.id).should == [s1]
      @user.authorized_schools(s2.id).should == []
    end
  end


  describe 'authorized students' do
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

    end


    it 'should return an empty array when user has access to no students' do
      @authorized_students_user.special_user_groups.clear
      @authorized_students_user.authorized_students.should == []
    end

    it 'should return all students in district when user has access to all students in district' do
      @authorized_students_user.special_user_groups.clear
      @authorized_students_user.special_user_groups.create!(:grouptype => SpecialUserGroup::ALL_STUDENTS_IN_DISTRICT, :district => @authorized_students_user.district)
      @authorized_students_user.authorized_students.should == @authorized_students_user.district.students
    end

    it 'should return all students in a school when user has access to all students in school' do
      @authorized_students_user.special_user_groups.clear
      @authorized_students_user.special_user_groups.create!(:grouptype => SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL, :district => @authorized_students_user.district, :school => @oneschool_elementary)
      @authorized_students_user.authorized_students.should == @oneschool_elementary.students
    end

    it 'should return all students in a school of a certain grade when user has access to all students in school for that grade' do
      @authorized_students_user.special_user_groups.clear
      @authorized_students_user.special_user_groups.create!(:grouptype => SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL,
          :district => @authorized_students_user.district, :school => @oneschool_elementary, :grade => 6)
      @authorized_students_user.authorized_students.should == @oneschool_elementary.enrollments.find_all_by_grade(6).collect(&:student).flatten
    end

    it 'should return all students in a group that a user belongs to' do
      @authorized_students_user.special_user_groups.clear
      @authorized_students_user.groups.clear
      @authorized_students_user.groups << @red_team
      @authorized_students_user.authorized_students.should == @red_team.students
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
      $stdout.should_receive(:write).with("You probably want to use += instead").once
      $stdout.should_receive(:write).with("\n").once
      u.roles << Role::ROLES.first
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

     it 'should remove existing ones whene there are none' do
       @user.update_attribute('existing_user_school_assignment_attributes',{})
       @user.user_school_assignments.should be_empty
     end

     it 'should change existing ones when there are none' do
       @user.update_attributes('existing_user_school_assignment_attributes'=>{@e1.id.to_s=>{:school_id=>'3'}})
       @e1.reload.school_id.should == 3
       @user.user_school_assignments.should ==[@e1]
     end

     it 'should not validate when changing existing to match' do
       @user.update_attributes('existing_user_school_assignment_attributes'=>{@e1.id.to_s=>{:school_id=>'2',:admin=>true}, @e2.id.to_s=>{:school_id=>'2'}})
       @user.should_not be_valid
       @user.user_school_assignments.first.errors_on(:admin).should_not be_nil
       @user.user_school_assignments.first.errors_on(:school_id).should_not be_nil
       @user.user_school_assignments.last.errors_on(:admin).should_not be_nil
       @user.user_school_assignments.last.errors_on(:school_id).should_not be_nil
     end

     it 'should add new user_school_assignment' do
       @user.update_attributes('new_user_school_assignment_attributes'=>[{:school_id=>1, :admin=>true}]).should be_true
       @user.user_school_assignments.find_by_school_id_and_admin(1,true).should_not be_nil
       @user.user_school_assignments[0..1].should == [@e1,@e2]
     end

     it 'should not new user_school_assignment that matches existing ' do
       @user.update_attributes('new_user_school_assignment_attributes'=>[{:school_id=>'1', :admin=>false}]).should be_false
       @user.should_not be_valid
     end

     it 'should not new user_school_assignment that matches changed existing ' do
       @user.update_attributes({'new_user_school_assignment_attributes'=>[{:school_id=>1, :admin=>true}],
                              'existing_user_school_assignment_attributes'=>{@e1.id.to_s=>{:admin=>true}}}
                             ).should be_false
       @user.should_not be_valid
     end


     it 'should not new user_school_assignment that matches itself' do
       @user.update_attributes('new_user_school_assignment_attributes'=>
                              [{:school_id=>'3', :admin=>false},{:school_id=>'3', :admin=>false}]).should be_false
       @user.should_not be_valid
     end


   end

   describe 'record_successful_login' do
    it 'should create a district log entry' do
      u=Factory(:user)
      u.record_successful_login
      u.logs.last.body.should == "Successful login of #{u.fullname}"
      log=u.district.logs.last
      log.body.should == "Successful login of #{u.fullname}"
      u.last_login.should == log.updated_at
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

end
