require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InterventionsHelper do
  include InterventionsHelper

  describe 'tiered_intervention_select' do
    it 'should have select tag with default blank' do
      tier=Tier.create!(:title=>'Tiered Intervention Select')
      int_def=Factory(:intervention_definition,:tier=>tier)
      d=tiered_intervention_definition_select([int_def])
      d.should have_tag("select#intervention_definition_id.fixed_width[onchange=?][name=?]",
        "$('spinnerdefinitions').show();form.onsubmit()" ,'intervention_definition[id]') do
          with_tag("option[value=?]","")
          with_tag("optgroup[label=?]",tier.to_s) do
            with_tag("option[value=?]",int_def.id,:text=>int_def.title)
          end
        end
  
        
    end

    it 'should have select_tag without blank' do
       tiered_intervention_definition_select([Factory(:intervention_definition)],false).should_not have_tag("option[value=?]","")
    end

  end

  describe 'tiered_quicklist' do

    it 'should return Quicklist is empty if there are no quicklist items' do
      tiered_quicklist(nil).should == 'Quicklist is empty.'
    end

    it 'should be sorted by objective then tier' do
      arr = []
      arr << mock_intervention_definition(:title => 'Quicklist1',:id=>6, :objective_definition => 'Objective 2',:tier=>'3-Basic')
      arr << mock_intervention_definition(:title => 'Quicklist2',:id=>2, :objective_definition => 'Objective 1',:tier=>'2-Basic')
      arr << mock_intervention_definition(:title => 'Quicklist2',:id=>2, :objective_definition => 'Objective 3',:tier=>'3-Basic')
      arr << mock_intervention_definition(:title => 'Quicklist2',:id=>2, :objective_definition => 'Objective 3',:tier=>'2-Basic')
      arr << mock_intervention_definition(:title => 'Quicklist2',:id=>2, :objective_definition => 'Objective 1',:tier=>'1-Basic')
      arr << mock_intervention_definition(:title => 'Quicklist3',:id=>3, :objective_definition => '',:tier=>'')

      tq=tiered_quicklist(arr)
      tq.should =~ /Objective 1 : 1-Basic.*Objective 1 : 2-Basic.*Objective 2 : 3-Basic.*Objective 3 : 2-Basic.*Objective 3 : 3-Basic/
      tq.should =~ /<select .*><option value=""/  #tests LH647
      tq.should have_tag("select#quicklist_item_intervention_definition_id[onchange=?]","form.submit()") do
        with_tag("option[value=?]","")
      end
   end

    it 'should return a form if there are  quicklist items' do
      g11=mock_intervention_definition(:title => 'Quicklist1',:id=>6, :objective_definition => 'Objective 1',:tier=>'1-Basic')
      g11b=mock_intervention_definition(:title => 'Quicklist2',:id=>2, :objective_definition => 'Objective 1',:tier=>'1-Basic')
      g00=mock_intervention_definition(:title => 'Quicklist3',:id=>3, :objective_definition => '',:tier=>'')
      
      
     
      arr=[g11,g00,g11b]
      tiered_quicklist(arr).should have_tag("form") do
        with_tag("option[value=?]",'','')
        with_tag("optgroup[label=?]","Objective 1 : 1-Basic") do
          with_tag("option[value=?]",g11.id, g11.title)
          with_tag("option[value=?]",g11b.id, g11b.title)
        end
        with_tag("option[value=?]",g00.id, g00.title)
        with_tag("noscript") do
          with_tag("input[type=submit][value=?]", 'Pick from Quicklist')
        end
      end
    end
  end
  #Delete this example and add some real ones or delete this file

=begin  
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
        self.should_receive(:selected_students_ids).any_number_of_times.and_return([1,2,3])
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
        self.should_receive(:selected_students_ids).any_number_of_times.and_return([1,2,3])
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
        self.should_receive(:selected_students_ids).any_number_of_times.and_return([1,2,3])
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
=end
end

