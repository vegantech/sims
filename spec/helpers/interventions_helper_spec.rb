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
      tq.should have_tag("select#intervention_definition_id[onchange=?]","form.submit()") do
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
end

