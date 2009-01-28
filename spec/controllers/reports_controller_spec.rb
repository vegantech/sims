require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReportsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

  describe 'student overall options' do
    integrate_views

    before do
      @district = Factory(:district)
      @student = Factory(:student)
    end

    it 'should show up' do
      get :student_overall_options, {}, {:user_id => 1, :district_id => @district.id, :selected_student => @student.id}

      response.should have_text(/Student Intervention Monitoring System/)
      response.should be_success
    end
  
    it 'should show checkbox for each section' do
      get :student_overall_options, {}, {:user_id => 1, :district_id => @district.id, :selected_student => @student.id}

      response.should be_success
      response.should have_tag('input[type=checkbox][checked=checked][id=report_params_top_summary]')
      response.should have_tag('input[type=checkbox][checked=checked][id=report_params_flags]')
      response.should have_tag('input[type=checkbox][checked=checked][id=report_params_team_notes]')
      response.should have_tag('input[type=checkbox][checked=checked][id=report_params_intervention_summary]')
    end
  end

  describe 'student overall report' do
    integrate_views

    before do
      @district = Factory(:district)
      @student = Factory(:student)
    end

    it 'should show top summary when selected' do
      controller.should_receive(:render).with(:partial => 'students/student')

      get :student_overall, {:report_params => {:format => "html", :top_summary => "1"}},
        {:user_id => 1, :district_id => @district.id, :selected_student => @student.id}

      response.should be_success
      response.should_not be_redirect
    end

    it 'should not show top summary when not selected' do
      controller.should_receive(:render).with(:partial => 'students/student').never
      get :student_overall, {:report_params => {:format => "html"}}, {:user_id => 1, :district_id => @district.id}
      response.should be_success
    end

    it 'should show team notes when selected' do
      @student.comments << StudentComment.create!(:body => 'Comment Body')
      @student.save!

      get :student_overall, {:report_params => {:format => "html", :team_notes => "1"}},
        {:user_id => 1, :district_id => @district.id, :selected_student => @student.id}

      response.should be_success
      response.should_not be_redirect
      response.should have_text(/Team Notes/)
      response.should have_text(/Comment Body/)
    end

    it 'should not show team notes when not selected' do
      controller.should_receive(:render).with(:partial => 'student_comment/comment').never

      get :student_overall, {:report_params => {:format => "html"}}, {:user_id => 1, :district_id => @district.id}

      response.should be_success
      response.should_not have_text(/Team Notes/)
      response.should_not have_text(/Comment Body/)
    end

    it 'should show flags when selected' do
      FlagsForStudentReport.should_receive(:render_html)
      get :student_overall, {:report_params => {:format => "html", :flags => "1"}}, {:user_id => 1, :district_id => @district.id}
      response.should be_success
    end

    it 'should not show flags when not selected' do
      FlagsForStudentReport.should_not_receive(:render_html)
      get :student_overall, {:report_params => {:format => "html"}}, {:user_id => 1, :district_id => @district.id}
      response.should be_success
    end

    # it 'should show student interventions when selected' do
    #   pending
    #   StudentInterventionsReport.should_receive(:render_html)
    #   get :student_overall, {:report_params => {:format => "html", :intervention_summary => "1"}}, {:user_id => 1, :district_id => @district.id}
    #   response.should be_success
    # end

    # it 'should not show student interventions when not selected' do
    #   StudentInterventionsReport.should_not_receive(:render_html)
    #   get :student_overall, {:format => "html"}, {:user_id => 1}
    #   response.should be_success
    # end

    # it 'should show extended profile when selected' do
    #   controller.should_receive(:render_component_as_string_with_notify_on_error)
    #   get :student_overall, {:report_params=>{:format => "html", :extended_profile => "1"}}, {:user_id => 1, :district_id => @district.id}
    #   response.should be_success
    # end

    # it 'should not show extended profile when not selected' do
    #   controller.should_not_receive(:render_component_as_string_with_notify_on_error)
    #   get :student_overall, {:format => "html"}, {:user_id => 1}
    #   response.should be_success
    # end

    it 'should show up as html when pdf and htmldoc gem is not installed' do
      #controller.should_receive(:defined?).and_return(false)
      if defined? PDF::HTMLDoc 
        OLD_HTMLDOC= PDF::HTMLDoc
        PDF.send(:remove_const, "HTMLDoc")
      end

      controller.should_not_receive(:render_to_pdf).and_return('PDF')
      get :student_overall, {:report_params => {:format=>"pdf"}}, {:user_id => 1, :district_id => @district.id}
      PDF.send(:const_set,"HTMLDoc", OLD_HTMLDOC) if defined? OLD_HTMLDOC
      response.should be_success
    end

    it 'should show up when pdf and htmldoc gem is installed' do
      unless defined? PDF::HTMLDoc 
        loaded = true
        module PDF; end
        PDF.const_set('HTMLDoc',2)
      end

      controller.should_receive(:render_to_pdf).and_return('PDF')

      get :student_overall, {:report_params => {:format => "pdf"}}, {:user_id => 1, :selected_student => @student.id}
      PDF.send(:remove_const, "HTMLDoc") if loaded
      response.should be_success
    end

    it 'should show up when html' do
      get :student_overall, {:report_params => {:format => "html"}}, {:user_id => 1, :district_id => @district.id}
      controller.should_not_receive(:render_to_pdf).and_return('PDF')
      response.should be_success
    end
  end

  describe 'team_notes' do
    describe 'GET' do
      it 'should set instance variables' do
        get :team_notes

        [:today, :start_date, :end_date].each do |sym|
          assigns[sym].should == Date.current
        end

        assigns[:filetypes].should == ['html', 'pdf', 'csv']
        assigns[:selected_filetype].should == 'html'
        assigns[:report].should be_nil
      end
    end

    describe 'POST' do
      describe 'with HTML format choice'
      it 'should return output of TeamNotesReport.render_html as report' do
        m = 'This is the HTML Team Notes Report Content'
        TeamNotesReport.stub!(:render_html=>m)

        post :team_notes, :start_date => {:month => 10, :day => 15, :year => 2008}, :end_date => {:month => 10, :day => 19, :year => 2008},
          "report_params"=>{"format"=>"html"}, "generate"=>"Generate Report"

        assigns[:today].should == Date.current
        assigns[:start_date].should == Date.new(2008, 10, 15)
        assigns[:end_date].should == Date.new(2008, 10, 19)

        assigns[:filetypes].should == ['html', 'pdf', 'csv']
        assigns[:selected_filetype].should == 'html'

        assigns[:report].class.should == String
        assigns[:report].should == m
      end

      describe 'and CSV format choice' do
        it 'returns output of TeamNotesReport.render_csv as report' do
          m = 'This is the CSV Team Notes Report Content'
          TeamNotesReport.stub!(:render_csv=>m)

          post :team_notes, {:generate => "Do the report", :report_params => {:format => 'csv'}}, {:user_id => 1}
          assigns[:report].should equal(m)
          assert_template nil # not sure how to do this with an Rspec matcher...

          response.should be_success
          response.body.should equal(m)
        end
      end # CSV

      describe 'and PDF format choice' do
        it 'returns output of TeamNotesReport.render_pdf as report' do
          m = 'This is the PDF Team Notes Report Content'
          TeamNotesReport.stub!(:render_pdf=>m)

          post :team_notes, {:generate => "Do the report", :report_params => {:format => 'pdf'}}, {:user_id => 1}
          assigns[:report].should equal(m)
          assert_template nil # not sure how to do this with an Rspec matcher...

          response.should be_success
          response.body.should equal(m)
        end
      end
    end
  end
end
