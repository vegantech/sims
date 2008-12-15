require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReportsController do
  it_should_behave_like "an authenticated controller"
  it_should_behave_like "an authorized controller"

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
        TeamNotesReport.stub!(:render_html).return(m)

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
          TeamNotesReport.stub!(:render_csv).return(m)

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
          TeamNotesReport.stub!(:render_pdf).return(m)

          post :team_notes, {:generate => "Do the report", :report_params => {:format => 'pdf'}}, {:user_id => 1}
          assigns[:report].should equal(m)
          assert_template nil # not sure how to do this with an Rspec matcher...

          response.should be_success
          response.body.should equal(m)
        end
      end # PDF
      
    end
  end
end
