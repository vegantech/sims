require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StudentsHelper do
  include StudentsHelper
  #Delete this example and add some real ones or delete this file
  it "should be included in the object returned by #helper" do
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(StudentsHelper)
  end

  describe 'active_intervention_select' do
    it 'should call intervention_group_checkbox for each intervention search by item' do
      district=mock_district(:search_intervention_by=>['tree','tree'])
      self.should_receive(:current_district).and_return(district)
      self.should_receive(:intervention_group_checkbox).with("tree").twice.and_return('test')
      active_intervention_select.should == 'testtest'
    end
    
    it 'should return an empty string when the district has no intervention search by' do
      district=mock_district(:search_intervention_by=>{})
      self.should_receive(:current_district).and_return(district)
      active_intervention_select.should == ''

    end
  end

  describe 'intervention_group_checkbox' do
    it 'should create a checkbox with label' do
      group=mock_district(:title=>"THE TITLE",:id=>'id1')
      o=intervention_group_checkbox(group)
      o.should include(label_tag(dom_id(group),"THE TITLE"))
      o.should include(check_box_tag("intervention_group_types[]",'id1', false, :id=>dom_id(group), :onclick=>"searchByIntervention()"))
                        

    end



  end




  describe 'selected_navigation' do
    it 'should return nil when there is only one student selected'  do
      self.should_receive("multiple_selected_students?").and_return(false)
      selected_navigation.should == nil
    end

    describe 'when multiple students selected' do
      it 'should show all of navigation when middle student is current' do
        self.should_receive("multiple_selected_students?").and_return(true)
        self.should_receive(:selected_student_ids).any_number_of_times.and_return([1,2,3])
        self.should_receive(:current_student_id).and_return(2)

        o=selected_navigation
        o.should match(/Student 2 of 3/)
        o.should have_tag("p") do 
          with_tag("a[href=?]",student_url(1),:text=>"<<")
          with_tag("a[href=?]",student_url(1),:text=>"Previous")
        
          with_tag("a[href=?]",student_url(3),:text=>">>")
          with_tag("a[href=?]",student_url(3),:text=>"Next")
        end

      end

      it 'should only show next and last when the first student is current' do
        self.should_receive("multiple_selected_students?").and_return(true)
        self.should_receive(:selected_student_ids).any_number_of_times.and_return([1,2,3])
        self.should_receive(:current_student_id).and_return(1)

        o=selected_navigation
        o.should match(/Student 1 of 3/)
        o.should have_tag("p") do 
          with_tag("a[href=?]",student_url(2),:text=>"Next")
          with_tag("a[href=?]",student_url(3),:text=>">>")
          without_tag("a",:text=>"<<")
          without_tag("a",:text=>"Previous")
        
        end


      end


      it 'should only show previous  and first when the last student is current' do
        self.should_receive("multiple_selected_students?").and_return(true)
        self.should_receive(:selected_student_ids).any_number_of_times.and_return([1,2,3])
        self.should_receive(:current_student_id).and_return(3)

        o=selected_navigation
        o.should match(/Student 3 of 3/)
        o.should have_tag("p") do 
          with_tag("a[href=?]",student_url(1),:text=>"<<")
          with_tag("a[href=?]",student_url(2),:text=>"Previous")
        
          without_tag("a",:text=>">>")
          without_tag("a",:text=>"Next")
        end


      end
    end

  end

  describe 'grade_select' do
    it 'should return the grades when there is only 1' do
      dog ='dog'
      grade_select([dog]).should == select(:search_criteria,:grade,[dog])
    end

    it 'should prepend a prompt when there are more than 1' do
      dog='dog'
      cat = 'cat'
      grade_select([dog,cat]).should == select(:search_criteria,:grade,['*',dog,cat])
    end
  end

  describe 'year_select' do
    it 'should return the years with a prompt when there is only 1' do
      dog ='dog'
      year_select([dog]).should == select(:search_criteria,:year,[['All','*'],dog])
    end

    it 'should prepend a prompt when there are more than 1' do
      dog='dog'
      cat = 'cat'
      year_select([dog,cat]).should == select(:search_criteria,:year,[['All','*'],dog,cat])
    end
  end

  describe 'group_select_options' do
    describe 'with all students' do
      it 'should return the groups with a prompt'
    end
    describe 'without all students' do
      it 'should return the groups with a prompt if there are more than 1'
      it 'should return the groups if there is 1'
    end
  end

  describe 'group_member_select_options' do
    before  do
      self.stub!(:current_school => mock_school)
      @mock_user = mock_user
      self.stub!(:current_user => @mock_user)
    end
    describe 'with all students' do
      it 'should return the group members with a prompt' do
        @mock_user.stub!('all_students_in_school?' => true)
        users = group_member_select_options([1])
        users.first.fullname.should == 'All Staff'
        users[1..-1].should == [1]
      end

    end
    describe 'without all students' do
      it 'should return the group members with a prompt if there are more than 1' do
        @mock_user.stub!('all_students_in_school?' => false)
        users=group_member_select_options([1,2])
        users.first.fullname.should == 'All Staff'
        users[1..-1].should == [1,2]
      end
      it 'should return the group members if there is 1' do
        @mock_user.stub!('all_students_in_school?' => false)
        group_member_select_options([1]).should == [1]
      end
    end
  end
  

end

