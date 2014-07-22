require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReportsController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"

  let(:user) {FactoryGirl.create(:user, :roles => "regular_user")}


  describe 'student_flag_summary' do
    render_views

    before do
      pending
      @school = FactoryGirl.create(:school)
      @district = FactoryGirl.create(:district)
      @from_url = request.env["HTTP_REFERER"] = 'http://one_step_back.org'
    end

    describe 'GET call' do
      describe 'without selected school' do
        it 'redirects back to HTTP_REFERER URL' do
          get :student_flag_summary, {:report_params => {:grade => 'A'}}, {:user_id => '1'}
          flash[:notice].should == 'Choose a school first'
          response.should redirect_to(@from_url)
        end
      end

      describe 'without grade' do
        it 'shows Choose Report Format Menu Inside of Layout' do
          School.should_receive(:find).with(@school.id).and_return(@school)

          get :student_flag_summary, {}, {:user_id => '1', :district_id => @district.id, :school_id => @school.id}

          response.should_not be_redirect
          response.should be_success
          response.should have_tag('h2', 'Choose Student Flag Report Format for Selected Students')
        end
      end

      describe 'with selected school and grade' do
        it 'shows Choose Report Format Menu Inside of Layout' do
          School.should_receive(:find).with(@school.id).and_return(@school)

          get :student_flag_summary, {:report_params => {:grade => 'A'}}, {:user_id => '1', :school_id => @school.id, :district_id => @district.id}

          response.should_not be_redirect
          response.should be_success
          response.should have_tag('h2', 'Choose Student Flag Report Format for Selected Students')
        end
      end
    end

    describe 'POST call' do
      describe 'with selected school' do
        describe 'and HTML format choice' do
          it 'renders output of StudentFlagReport.render_html' do
            m = 'This is the HTML Student Flag Report Content'
            School.should_receive(:find).with(@school.id).and_return(@school)
            StudentFlagReport.stub!(:render_html=>m)

            post :student_flag_summary, {:generate => "Do the report", :report_params => {:format => 'html', :grade => 'B'}},
                 {:user_id => '1', :school_id => @school.id, :district_id => @district.id}

            response.should_not be_redirect
            assigns(:report).should equal(m)
            response.should render_template('reports/student_flag_summary')

            response.should be_success
            response.should have_text(/#{m}/)
          end
        end # HTML

        describe 'and CSV format choice' do
          it 'returns output of StudentFlagReport.render_csv as report' do
            m = 'This is the CSV Student Flag Report Content'
            School.should_receive(:find).with(@school.id).and_return(@school)
            StudentFlagReport.stub!(:render_csv=>m)

            post :student_flag_summary, {:generate => "Do the report", :report_params => {:format => 'csv', :grade => 'C'}},
                 {:user_id => '1', :school_id => @school.id}

            response.should_not be_redirect
            response.should be_success
            assigns(:report).should equal(m)
            assert_template nil # not sure how to do this with an Rspec matcher...

            response.should be_success
            response.body.should equal(m)
          end
        end # CSV

        describe 'and PDF format choice' do
          it 'returns output of StudentFlagReport.render_pdf as report' do
            m = 'This is the PDF Student Flag Report Content'
            School.should_receive(:find).with(@school.id).and_return(@school)
            StudentFlagReport.stub!(:render_pdf=>m)

            post :student_flag_summary, {:generate => "Do the report", :report_params => {:format => 'pdf', :grade => 'D'}},
                 {:user_id => '1', :school_id => @school.id}

            response.should_not be_redirect
            response.should be_success
            assigns(:report).should equal(m)
            assert_template nil # not sure how to do this with an Rspec matcher...

            response.should be_success
            response.body.should equal(m)
          end
        end # PDF
      end # with student
    end # POST
  end # student_flag_summary

  describe 'student overall options' do

    render_views

    before do
      @district = FactoryGirl.create(:district)
      @student = FactoryGirl.create(:student)
      controller.stub!(:current_user => user)
      @student.should_receive(:belongs_to_user?).and_return(true)
      Student.should_receive(:find_by_id).with(@student.id.to_s).and_return(@student)
    end

    it 'should show up' do
      get :student_overall_options, {:student_id => @student.id.to_s}, {:user_id => '1', :district_id => @district.id, :selected_student => @student.id.to_s}
      response.body.should have_content("Student Intervention Monitoring System")
      response.should be_success
    end

    it 'should show checkbox for each section' do
      get :student_overall_options, {:student_id => @student.id.to_s}, {:user_id => '1', :district_id => @district.id, :selected_student => @student.id.to_s}

      response.should be_success
      response.body.should have_selector('input[type=checkbox][checked=checked][id=report_params_top_summary]')
      response.body.should have_selector('input[type=checkbox][checked=checked][id=report_params_flags]')
      response.body.should have_selector('input[type=checkbox][checked=checked][id=report_params_team_notes]')
      response.body.should have_selector('input[type=checkbox][checked=checked][id=report_params_intervention_summary]')
    end
  end

  describe 'student overall report' do
    render_views

    before do
      @district = FactoryGirl.create(:district)
      @student = FactoryGirl.create(:student)
      controller.stub!(:current_user => user)
      @student.should_receive(:belongs_to_user?).and_return(true)
      Student.should_receive(:find_by_id).with(@student.id.to_s).and_return(@student)
    end

    it 'should show top summary when selected' do

      get :student_overall, {:report_params => {:format => "html", :top_summary => "1"},:student_id => @student.id.to_s},
          {:user_id => '1', :district_id => @district.id, :selected_student => @student.id.to_s}

      response.should be_success
      response.should_not be_redirect
      response.body.should have_selector("div#student_profile")
    end

    it 'should not show top summary when not selected' do
      get :student_overall, {:report_params => {:format => "html"}, :student_id => @student.id.to_s}, {:user_id => '1', :district_id => @district.id}
      response.should be_success
      response.should_not be_redirect
      response.body.should_not have_selector("div#student_profile")
    end

    it 'should show team notes when selected' do
      @student.comments << StudentComment.create!(:body => 'Comment Body')
      @student.save!

      get :student_overall, {:report_params => {:format => "html", :team_notes => "1"},:student_id => @student.id.to_s},
          {:user_id => '1', :district_id => @district.id, :selected_student => @student.id.to_s}

      response.should be_success
      response.should_not be_redirect
      response.body.should have_content("Team Notes")
      response.body.should have_content("Comment Body")
    end

    it 'should not show team notes when not selected' do

      get :student_overall, {:report_params => {:format => "html"},:student_id => @student.id.to_s}, {:user_id => '1', :district_id => @district.id}

      response.should be_success
      response.should_not have_content("Team Notes")
      response.should_not have_content("Comment Body")
    end

    it 'should show flags when selected' do
      @student.flags << SystemFlag.create!(:category => 'attendance', :reason => 'Late every day')

      get :student_overall, {:report_params => {:format => "html", :flags => "1"},:student_id => @student.id.to_s},
          {:user_id => '1', :district_id => @district.id, :selected_student => @student.id.to_s}

      response.should be_success
      response.should render_template('reports/_flags_for_student')
    end

    it 'should not show flags when not selected' do
      get :student_overall, {:report_params => {:format => "html"}, :student_id => @student.id.to_s}, {:user_id => '1', :district_id => @district.id}
      response.should be_success
      response.should_not render_template('reports/_flags_for_student')
    end

    it 'should show student interventions when selected' do
      intervention = FactoryGirl.create(:intervention, :student_id => @student.id.to_s)
      @student.interventions << intervention
      @student.interventions.should_not be_empty

      get :student_overall, {:report_params => {:format => "html", :intervention_summary => "1"},:student_id => @student.id.to_s},
          {:user_id => '1', :district_id => @district.id, :selected_student => @student.id.to_s}

      response.should be_success
      response.should render_template("students/_intervention_table")
    end

    it 'should not show student interventions when not selected' do
      get :student_overall, {:format => "html",:student_id => @student.id.to_s}, {:user_id => '1', :district_id => @district.id}
      response.should be_success
      response.should_not render_template("students/_intervention_table")
    end

    # it 'should show extended profile when selected' do
    #   controller.should_receive(:render_component_as_string_with_notify_on_error)
    #   get :student_overall, {:report_params=>{:format => "html", :extended_profile => "1"}}, {:user_id => '1', :district_id => @district.id}
    #   response.should be_success
    # end

    # it 'should not show extended profile when not selected' do
    #   controller.should_not_receive(:render_component_as_string_with_notify_on_error)
    #   get :student_overall, {:format => "html"}, {:user_id => '1'}
    #   response.should be_success
    # end

    it 'should show up as html when pdf and htmldoc gem is not installed' do
      #controller.should_receive(:defined?).and_return(false)
      if defined? PDF::HTMLDoc
        OLD_HTMLDOC= PDF::HTMLDoc
        PDF.send(:remove_const, "HTMLDoc")
      end

      controller.should_not_receive(:render_to_pdf).and_return('PDF')
      get :student_overall, {:report_params => {:format=>"pdf"},:student_id => @student.id.to_s}, {:user_id => '1', :district_id => @district.id}
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

      get :student_overall, {:report_params => {:format => 'pdf'},:student_id => @student.id.to_s}, {:user_id => '1', :selected_student => @student.id.to_s}
      PDF.send(:remove_const, "HTMLDoc") if loaded
      response.should be_success
    end

    it 'should show up when html' do
      get :student_overall, {:report_params => {:format => "html"},:student_id => @student.id.to_s}, {:user_id => '1', :district_id => @district.id}
      controller.should_not_receive(:render_to_pdf).and_return('PDF')
      response.should be_success
    end
  end

  describe 'team_notes' do
    describe 'GET' do
      it 'should set instance variables' do
        get :team_notes

        [:today, :start_date, :end_date].each do |sym|
          assigns(sym).should == Date.current
        end

        assigns(:filetypes).should == ['html', 'pdf', 'csv']
        assigns(:selected_filetype).should == 'html'
        assigns(:report).should be_nil
      end
    end

    describe 'POST' do
      before :all do
        pending "This needs to be redone"
      end
      describe 'with HTML format choice'
      it 'should return output of TeamNotesReport.render_html as report' do
        m = 'This is the HTML Team Notes Report Content'
        TeamNotesReport.stub!(:render_html=>m)

        post :team_notes, :start_date => {:month => 10, :day => 15, :year => 2008}, :end_date => {:month => 10, :day => 19, :year => 2008},
                          "report_params"=>{"format"=>"html"}, "generate"=>"Generate Report"

        assigns(:today).should == Date.current
        assigns(:start_date).should == Date.new(2008, 10, 15)
        assigns(:end_date).should == Date.new(2008, 10, 19)

        assigns(:filetypes).should == ['html', 'pdf', 'csv']
        assigns(:selected_filetype).should == 'html'

        assigns(:report).class.should == String
        assigns(:report).should == m
      end

      describe 'and CSV format choice' do
        it 'returns output of TeamNotesReport.render_csv as report' do
          m = 'This is the CSV Team Notes Report Content'
          TeamNotesReport.stub!(:render_csv=>m)

          post :team_notes, {:generate => "Do the report", :report_params => {:format => 'csv'}}, {:user_id => '1'}
          assigns(:report).should equal(m)
          assert_template nil # not sure how to do this with an Rspec matcher...

          response.should be_success
          response.body.should ==(m)
        end
      end # CSV

      describe 'and PDF format choice' do
        it 'returns output of TeamNotesReport.render_pdf as report' do
          m = 'This is the PDF Team Notes Report Content'
          TeamNotesReport.stub!(:render_pdf=>m)

          post :team_notes, {:generate => "Do the report", :report_params => {:format => 'pdf'}}, {:user_id => '1'}
          assigns(:report).should equal(m)
          assert_template nil # not sure how to do this with an Rspec matcher...

          response.should be_success
          response.body.should ==(m)
        end
      end
    end
  end

  describe 'user_interventions' do
    describe 'GET' do
      it 'should set instance variables' do
        controller.stub!(:current_user => user)
        get :user_interventions

        assigns(:filetypes).should == ['html', 'pdf', 'csv']
        assigns(:selected_filetype).should == 'html'
        assigns(:report).should be_nil
      end
    end

    describe 'POST' do
      before :all do
        pending "Fix these"
      end
      describe 'with HTML format choice'
      it 'should return output of UserInterventionsReport.render_html as report' do
        m = 'This is the User Interventions Report Content'
        #UserInterventionsReport.stub!(:render_html => m)

        post :user_interventions, "report_params" => {"format"=>"html"}, "generate" => "Generate Report"

        assigns(:filetypes).should == ['html', 'pdf', 'csv']
        assigns(:selected_filetype).should == 'html'

        assigns(:report).class.should == String
        assigns(:report).should == m
      end

      describe 'and CSV format choice' do
        it 'returns output of UserInterventionsReport.render_csv as report' do
          m = 'This is the CSV User Interventions Report Content'
         # UserInterventionsReport.stub!(:render_csv => m)

          post :user_interventions, {:generate => "Do the report", :report_params => {:format => 'csv'}}, {:user_id => '1'}
          assigns(:report).should equal(m)
          assert_template nil # not sure how to do this with an Rspec matcher...

          response.should be_success
          response.body.should ==(m)
        end
      end # CSV

      describe 'and PDF format choice' do
        it 'returns output of UserInterventionsReport.render_pdf as report' do
          m = 'This is the PDF User Interventions Report Content'
          #UserInterventionsReport.stub!(:render_pdf => m)

          post :user_interventions, {:generate => "Do the report", :report_params => {:format => 'pdf'}}, {:user_id => '1'}
          assigns(:report).should equal(m)
          assert_template nil # not sure how to do this with an Rspec matcher...

          response.should be_success
          response.body.should ==(m)
        end
      end
    end
  end

  describe 'build_date' do
    it 'should parse a valid date' do
      subject.send(:build_date, {year:2012, month:01,day:31}).should == Date.new(2012,01,31)
    end
    it 'should revert to today when the date is invalid' do
      subject.send(:build_date, {year:2012, month:02,day:31}).should == Date.today
      flash[:notice].should == "Invalid date chosen.  Used today instead."
    end
    it 'should return nil if the date hash is nil' do
      subject.send(:build_date, nil).should be_nil
    end
  end
end
