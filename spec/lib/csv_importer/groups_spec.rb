require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CSVImporter::AllStudentsInSchools do
  describe "importer"  do
    it 'should work properly' do
      #
      School.delete_all
      Group.delete_all
      District.delete_all


      @district = Factory(:district)
      @school_with_link = Factory(:school, :district_school_id => '2', :district_id => @district.id)
      @another_linked_school = Factory(:school, :district_school_id => '1', :district_id => @district.id)
      @school_no_link = Factory(:school, :district_id => @district.id)
      @manual_group = Factory(:group, :school_id => @school_with_link.id, :title => "Manual group at linked school")
      @manual_group2 = Factory(:group, :school_id => @school_no_link.id, :title => "Manual group at unlinked school")
      @existing_group = Factory(:group, :school_id => @school_no_link.id, :title => "Existing Group", :district_group_id => 'existing_group')
      @existing_group2 = Factory(:group, :school_id => @school_with_link.id, :title => "Existing Group fix name", :district_group_id => 'existing_group')
      @group_to_remove = Factory(:group, :school_id => @school_with_link.id, :title => "Group to Remove", :district_group_id => 'Remove Me')
      @school_no_link.groups.collect(&:title).to_set.should == ["Manual group at unlinked school", "Existing Group"].to_set

      @school_no_link.groups.reload.collect(&:title).to_set.should == ["Manual group at unlinked school", "Existing Group"].to_set

      @i=CSVImporter::Groups.new "#{Rails.root}/spec/csv/groups.csv",@district
      @i.import

      @school_no_link.groups.reload.collect(&:title).to_set.should == ["Manual group at unlinked school", "Existing Group"].to_set
      @i.messages.should include("Successful import of groups.csv")
      @i.messages.should include("duplicate groups for duplicate_group and 2 using one titled Duplicated Group")
      @another_linked_school.groups.reload.collect(&:title).to_set.should == ["New Group"].to_set
      @school_no_link.groups.reload.collect(&:title).to_set.should == ["Manual group at unlinked school", "Existing Group"].to_set
      @school_with_link.groups.reload.collect(&:title).to_set.should == ["Existing Group", "New Group", "Duplicated Group", "Manual group at linked school"].to_set
    end

  end
end




