# == Schema Information
# Schema version: 20101101011500
#
# Table name: districts
#
#  id                    :integer(4)      not null, primary key
#  name                  :string(255)
#  abbrev                :string(255)
#  state_dpi_num         :integer(4)
#  created_at            :datetime
#  updated_at            :datetime
#  admin                 :boolean(1)
#  logo_file_name        :string(255)
#  logo_content_type     :string(255)
#  logo_file_size        :integer(4)
#  logo_updated_at       :datetime
#  marked_state_goal_ids :string(255)
#  key                   :string(255)     default("")
#  previous_key          :string(255)     default("")
#  lock_tier             :boolean(1)
#  restrict_free_lunch   :boolean(1)      default(TRUE)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe District do

  before(:all) do
    @local_district = District.find_by_name("GD_TEST") || Factory(:district, :name=>"GD_TEST", :abbrev=>"CKAZZ2")
    @district2 = District.find_by_name("district_2") || Factory(:district, :name=>"district_2", :abbrev=>"DIST2")
    @state_district = District.admin.first ||  Factory(:district, :admin=>true)
  end
  it 'should be valid' do
    FactoryGirl.build(:district).should be_valid
  end

  describe 'active_checklist_definition method' do
    before(:all) do
      ChecklistDefinition.delete_all
      @ld_cd = Factory(:checklist_definition, :district => @local_district)
    end

    describe 'with active district definition' do
      it "should return district's active definition" do
        @ld_cd.update_attribute(:active,true)
        @local_district.active_checklist_definition.should == @ld_cd
      end
    end
    describe 'without active district definition' do
      it 'should return nil' do
        @ld_cd.update_attribute(:active,false)
        @local_district.active_checklist_definition.should be_nil
      end
    end
  end

  it "grades should return GRADES constant" do
    District.new.grades.should == District::GRADES
  end

  it 'should find intervention defintiion by id' do
    district=District.new
    district.should_receive(:id).and_return(5)
    InterventionDefinition.should_receive(:find).with(3,:include=>{:intervention_cluster=>{:objective_definition=>:goal_definition}},
                                                       :conditions=>{'goal_definitions.district_id'=>5}).and_return(true)
    district.find_intervention_definition_by_id(3).should == true
  end

  it 'should search intervention_by' do
    district=District.new
    district.should_receive(:objective_definitions).and_return([])
    district.search_intervention_by.should == []
  end

 describe 'admin district' do
    it 'should return the state admin district for a leaf (normal) district' do
      @local_district.admin_district.should == @state_district
    end
  end

  describe 'key validation' do
    it 'should fail validation if there is a previous key and the key is changed' do
      @local_district.previous_key = 'different'
      @local_district.key = 'notdog'
      @local_district.save!

      @local_district.key = 'dog'
      @local_district.should_not be_valid

      @local_district.previous_key = ''
      @local_district.should be_valid

      @local_district.save
      @local_district.key= 'cat'
      @local_district.save

      @local_district.previous_key.should == 'notdog'

    end

  end


  it 'should have spec for check keys'

  describe 'claim student' do
    it 'should not call external verification if it is not setup' do
      district=District.new
      VerifyStudentInDistrictExternally.should_receive(:enabled?).and_return(false)
      VerifyStudentInDistrictExternally.should_not_receive(:verify)
      district.claim(Student.new)
    end

    it 'should call external verification if it is setup' do
      district=District.new
      VerifyStudentInDistrictExternally.should_receive(:enabled?).and_return(true)
      VerifyStudentInDistrictExternally.should_receive(:verify)
      district.claim(Student.new)
    end

    #initially I just want to try to claim the student if STUDENT_LOCATION_VERIFICATION_URL is defined
    it 'should have specs'

    it 'should' do
      pending  %q{check hash
      2. if districtless check historical enrollments, if last district was current district allow reclaimaing
       3.check dpi location verification}
    end
  end

  describe 'can_claim?' do
    it 'should have specs'
  end

  describe 'find_by_subdomain' do
    let!(:district) {District.delete_all;Factory(:district, :abbrev => 'rspec123')}
    describe 'with matching subdomain' do
      specify{ District.find_by_subdomain('rspec123').should == district }
      specify{ District.find_by_subdomain('rspec123-wi-us').should == district }
    end

    it 'should return the  first normal district when there is only 1' do
      District.normal.count.should == 1
      District.find_by_subdomain('nothere').should == district
    end

    it 'should return the first admin district when there is only 1 district' do
      district.toggle!(:admin)
      District.count.should == 1
      District.find_by_subdomain('nothere').should == district
    end

    it 'should not return the first admin district when there are multiple normal' do
      other_district2 = Factory(:district)
      other_district1 = Factory(:district)
      new_district = District.find_by_subdomain('nothere')
      new_district.should be_new_record
      new_district.name.should == "Please Select a District"
    end


    it 'should create a new district when not found' do
      other_district = Factory(:district)
      new_district= District.find_by_subdomain('nothere')
      new_district.should be_new_record
      new_district.name.should == "Please Select a District"
    end
  end

  describe 'boolean settings' do
    subject {District.new}

    describe 'restrict_free_lunch' do
      its(:restrict_free_lunch?) {should be}
    end

    District::BOOLEAN_SETTINGS.each do |setting|
      describe setting do
        ["1",true].each do |truth_value|
          describe "when set to #{truth_value}" do
            subject {District.new setting => truth_value }
            its("#{setting}?") {should be_true}
          end
        end
        describe setting do
          ["0",nil,false].each do |truth_value|
            describe "when set to #{truth_value}" do
              subject {District.new setting => truth_value }
              its("#{setting}?") {should be_false}
            end
          end
        end
      end

    end
  end
#  describe 'when set to nil' do
#    subject {District.new :restrict_free_lunch => nil}
#        its(:restrict_free_lunch?) {should be_false}
#      end
#      describe 'when set to "0"' do
#        subject {District.new :restrict_free_lunch => "0"}
#        its(:restrict_free_lunch?) {should be_false}
#      end
#      describe 'when set to "1"' do
#        subject {District.new :restrict_free_lunch => "1"}
#        its(:restrict_free_lunch?) {should be_true}
#      end
#      describe 'when set to false' do
#        subject {District.new :restrict_free_lunch => false}
#        its(:restrict_free_lunch?) {should be_false}
#      end
#      describe 'when set to true' do
#        subject {District.new :restrict_free_lunch => true}
#        its(:restrict_free_lunch?) {should be}
#      end
#
#    end
#  end
#
end
