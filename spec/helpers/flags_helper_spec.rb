require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FlagsHelper do

  describe 'status_display' do
    it 'should combine intervention current and custom flags' do
      student = "STUDENT"
      change = "CHANGE"

      helper.should_receive(:intervention_status).with(student).and_return("INTERVENTION STATUS ")
      helper.should_receive(:current_flags).with(student,change).and_return('CURRENT FLAGS ')
      helper.should_receive(:team_concerns).with(student).and_return('TEAM CONCERNS ')
      helper.should_receive(:team_notes).with(student).and_return('TEAM NOTES ')
      helper.should_receive(:ignore_flags).with(student).and_return('IGNORE FLAGS ')
      helper.should_receive(:custom_flags).with(student).and_return('CUSTOM FLAGS')

      helper.status_display(student,change).should == 'INTERVENTION STATUS CURRENT FLAGS TEAM CONCERNS TEAM NOTES IGNORE FLAGS CUSTOM FLAGS'
    end
  end

  describe 'team_concerns' do
    it 'should return an empty string when there are no concerns' do
      helper.team_concerns(Student.new).should == ''
    end

    it 'should return an image when there is  concern' do
      student=Factory(:student)
      student.team_consultations.create!
      helper.team_concerns(student).should ==
        "<img alt=\"Comments\" onmouseout=\"return nd();\" onmouseover=\"return overlib('Open Team Consultations');\" src=\"/assets/comments.png\" /> "
    end

  end

  describe 'default_show_team_concerns?' do
    it 'should be false if the district setting is disabled' do
      helper.stub(:team_concerns? => true)
      helper.stub(:current_district => District.new)
      helper.default_show_team_concerns?(Student.new,User.new).should be_false
    end
    it 'should be false if there are no pending concerns'do
      helper.stub(:team_concerns? => false)
      helper.stub(:current_district => District.new(:show_team_consultations_if_pending => true))
      helper.default_show_team_concerns?(Student.new,User.new).should be_false
    end
    it 'should be true if te district setting is enabled and there are pending concerns' do
      TeamConsultation.stub!(:pending_for_user => [2])
      helper.stub(:current_district => District.new(:show_team_consultations_if_pending => true))
      helper.default_show_team_concerns?(Student.new,User.new).should be_true
    end

  end

  describe 'team_notes' do
    it 'should return an empty string when there are no comments' do
      team_notes(Student.new).should == ''
    end

    it 'should return an image when there are comments' do
      student=Factory(:student)
      student.comments.create!(:body=>'This si comment 1')
      student.comments.create!(:body=>'This si comment 2')
      helper.team_notes(student).should == helper.image_with_popup("note.png", "2 team notes")

    end

  end

  describe 'image_with_popup' do
    it 'should return an imagetag with an onmouseover and onmouse_out' do
      result = helper.image_with_popup("dog.jpg", "This is the popup")
      result.should == %q{<img alt="Dog" onmouseout="return nd();" onmouseover="return overlib('This is the popup');" src="/assets/dog.jpg" /> }
    end
  end

  describe 'custom flags' do
    it 'should return empty string when student has no custom flags' do
      student = mock_student(:custom_flags => [])
      helper.custom_flags(student).should == ""
    end

    it 'should show the custom flag icon with the summary as a popup' do
      flag = mock_flag(:summary => "Custom Flag Summary", :any? => true)
      student = mock_student(:custom_flags => [flag])
      helper.should_receive(:image_with_popup).with("C.gif", 'Custom Flags : Custom Flag Summary').and_return('RSPEC CUSTOM FLAGS')
      helper.custom_flags(student).should == "RSPEC CUSTOM FLAGS"
    end
  end

  describe 'current_flags' do
    describe 'without flags' do
      it 'should return blank string' do
        student = mock_student(:current_flags => [])
        helper.current_flags(student).should == ""
      end
    end

    describe 'with flags' do
      describe 'not changeable' do
        it 'should show current flags' do
          cf = mock_flag(:summary => 'Current Flag Summary')
          student = mock_student(:current_flags => {'math' => [cf]})
          helper.should_receive(:image_with_popup).with("M.gif", "Math : Current Flag Summary").and_return('Rspec Current Flags')
          helper.current_flags(student).should == 'Rspec Current Flags'
        end
      end

      describe 'changeable' do
        it 'should return a form' do
          cf = mock_flag(:category => 'languagearts', :summary => 'Current Flag Summary', :icon => 'CF.png')
          student = mock_student(:current_flags => {'math' => [cf]})

          helper.current_flags(student, true).should ==  "<form accept-charset=\"UTF-8\" action=\"/ignore_flags/new?category=languagearts\" data-remote=\"true\" method=\"get\" style=\"display:inline\"><div style=\"margin:0;padding:0;display:inline\"><input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\" /></div><input onmouseout=\"return nd();\" onmouseover=\"return overlib('Math : Current Flag Summary');\" src=\"/assets/CF.png\" type=\"image\" /></form>"
       end
      end
    end
  end

  describe 'ignore_flags' do
    describe 'for student without ignore flags' do
      it 'should return blank string' do
        student = mock_student(:ignore_flags => [])
        helper.ignore_flags(student).should == ''
      end
    end

    describe 'for student with ignore flags' do
      describe 'not changeable' do
        it 'should show I.gif image with popup message' do
          flag = mock_flag(:summary => 'Ignore Flag Summary')
          student = mock_student(:ignore_flags => [flag])
          helper.should_receive(:image_with_popup).with("I.gif", "Ignore Flags :  Ignore Flag Summary").and_return('Rspec Ignore Flags')
          helper.ignore_flags(student).should == 'Rspec Ignore Flags'
        end
      end

      describe 'passed changeable set to true' do
        it 'should return form remote tag output' do
          u = mock_user(:to_s => 'Mock User')

          flag = mock_flag(:category => 'SomeCategory', :reason => 'Just because', :user => u, :created_at => Date.new(2009, 1, 12).to_time,
            :icon => 'fubar.png')

          student = mock_student(:ignore_flags => [flag])
          pending "Testing on rcr"
          helper.ignore_flags(student, true).should == "<form action=\"/custom_flags/unignore_flag/#{flag.id}\" class=\"flag_button\" method=\"post\"" +
            " onsubmit=\"new Ajax.Request('/custom_flags/unignore_flag/#{flag.id}'," +
            " {asynchronous:true, evalScripts:true, parameters:Form.serialize(this)}); return false;\"" +
            " style=\"display:inline\"><input onmouseout=\"return nd();\"" +
            " onmouseover=\"return overlib('Somecategory - Just because  by Mock User on Mon Jan 12 00:00:00 -0600 2009');\"" +
            " src=\"/assets/fubar.png\" type=\"image\" /></form>"
        end
      end
    end
  end
end
