require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CSVImporter::StudentGroups do
  describe "importer"  do
    it 'should work properly' do
      #unlinked school, unlinked group, unlinked user
      Student.delete_all
      School.delete_all
      Group.delete_all
      District.delete_all


      @district = Factory(:district)
      @school_no_link = Factory(:school, :district_id => @district.id)
      @school_with_link = Factory(:school, :district_school_id => '2', :district_id => @district.id)
      @unlinked_group_at_linked_school =  Factory(:group, :school_id => @school_with_link.id, :title => "Unlinked group at linked school")
      @linked_group_at_unlinked_school = Factory(:group, :school_id => @school_no_link.id, :title => "linked group at unlinked school", :district_group_id=>'linked_at_unlinked')
      @unlinked_group_at_unlinked_school = Factory(:group, :school_id => @school_no_link.id, :title => "unlinked group at unlinked school")

      @linked_to_empty = Factory(:group, :school_id => @school_with_link.id, :title => "should get emptied", :district_group_id=>'linked_to_empty')
      @existing_group = Factory(:group, :school_id => @school_with_link.id, :title => "existing group", :district_group_id=>'existing_group')
      @new_group = Factory(:group, :school_id => @school_with_link.id, :title => "new group", :district_group_id=>'new_group')




      @unlinked_user = Factory(:student, :district_id => @district.id)
      @linked_principal = Factory(:student, :district_id => @district.id, :district_student_id => 'linked_principal')
      @linked_user = Factory(:student, :district_id => @district.id, :district_student_id => 'linked_user')

      [@unlinked_group_at_linked_school,@linked_group_at_unlinked_school,@unlinked_group_at_unlinked_school,@linked_to_empty,@existing_group].each do |g|
        g.students << @unlinked_user
        g.students << @linked_user
      end

      @existing_group.students << @linked_principal

      @i=CSVImporter::StudentGroups.new "#{Rails.root}/spec/csv/student_groups.csv",@district
      @i.import

      #make sure unlinked data remains untouched
      [@unlinked_group_at_linked_school,@linked_group_at_unlinked_school,@unlinked_group_at_unlinked_school].each do |g|
        g.student_ids.sort.should == [@unlinked_user.id, @linked_user.id].sort
      end

      @linked_to_empty.student_ids.should == [@unlinked_user.id]
      @existing_group.student_ids.sort.should == [@unlinked_user.id,@linked_principal.id].sort
      @new_group.student_ids.sort.should == [@linked_user.id,@linked_principal.id].sort


    end

  end
end




