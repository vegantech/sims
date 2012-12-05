require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InterventionsHelper do

  describe 'tiered_intervention_select' do
    it 'should have select tag with default blank' do
      tier=Tier.create!(:title=>'Tiered Intervention Select')
      int_def=Factory(:intervention_definition,:tier=>tier)
      d=helper.tiered_intervention_definition_select([int_def])
      d.should have_tag("select#intervention_definition_id.fixed_width[onchange=\"$('spinnerdefinitions').show();simulate(this.form,'submit')\"]",:with=>{ :name => 'intervention_definition[id]'}) do
          with_tag("option", :with => {:value =>""})
          with_tag("optgroup",:with => {:label=>tier.to_s}) do
            with_option(int_def.title, :with => {:value => int_def.id})
          end
        end


    end

    it 'should have select_tag without blank' do
       helper.tiered_intervention_definition_select([Factory(:intervention_definition)],false).should_not have_tag("option",:with =>{ :value =>""})
    end

  end

  describe 'tiered_quicklist' do

    it 'should return Quicklist is empty if there are no quicklist items' do
      helper.tiered_quicklist(nil).should == 'Quicklist is empty.'
    end

    it 'should be sorted by objective then tier' do
      arr = []
      arr << mock_intervention_definition(:title => 'Quicklist1',:id=>6, :objective_definition => 'Objective 2',:tier=>'3-Basic')
      arr << mock_intervention_definition(:title => 'Quicklist2',:id=>2, :objective_definition => 'Objective 1',:tier=>'2-Basic')
      arr << mock_intervention_definition(:title => 'Quicklist2',:id=>2, :objective_definition => 'Objective 3',:tier=>'3-Basic')
      arr << mock_intervention_definition(:title => 'Quicklist2',:id=>2, :objective_definition => 'Objective 3',:tier=>'2-Basic')
      arr << mock_intervention_definition(:title => 'Quicklist2',:id=>2, :objective_definition => 'Objective 1',:tier=>'1-Basic')
      arr << mock_intervention_definition(:title => 'Quicklist3',:id=>3, :objective_definition => '',:tier=>'')

      tq=helper.tiered_quicklist(arr)
      tq.should =~ /Objective 1 : 1-Basic.*Objective 1 : 2-Basic.*Objective 2 : 3-Basic.*Objective 3 : 2-Basic.*Objective 3 : 3-Basic/
      tq.should =~ /<select .*><option value=""/  #tests LH647
      tq.should have_tag("select#intervention_definition_id[onchange=\"form.submit()\"]") do
        with_tag("option", :value=>"")
      end
   end

    it 'should return a form if there are  quicklist items' do
      g11=mock_intervention_definition(:title => 'Quicklist1',:id=>6, :objective_definition => 'Objective 1',:tier=>'1-Basic')
      g11b=mock_intervention_definition(:title => 'Quicklist2',:id=>2, :objective_definition => 'Objective 1',:tier=>'1-Basic')
      g00=mock_intervention_definition(:title => 'Quicklist3',:id=>3, :objective_definition => '',:tier=>'')



      arr=[g11,g00,g11b]
      helper.tiered_quicklist(arr).should have_tag("form") do
        with_tag("option",:value => '')
        with_tag("optgroup", :label => "Objective 1 : 1-Basic") do
          with_option(g11.title, :value => g11.id, :text => g11.title)
          with_option(g11b.title, :value=>g11b.id, :text => g11b.title)
        end
        with_tag("option", :value=>g00.id, :text => g00.title)
        with_tag("noscript") do
          with_tag("input[type=submit]", :value=> 'Pick from Quicklist')
        end
      end
    end
  end

  describe 'custom_intervention_enabled?' do
    it 'should return false when it is false for the current user' do
      helper.should_receive(:current_user).and_return(mock_user(:custom_interventions_enabled? => false))
      helper.custom_intervention_enabled?.should == false

    end

    it 'should return true when it is true for the current user' do
      helper.should_receive(:current_user).and_return(mock_user(:custom_interventions_enabled? => true))
      helper.custom_intervention_enabled?.should == true
    end
  end
end

