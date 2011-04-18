require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HtmlCsvText do
  before :all do
    now = "3:33 06/04/09".to_time
    Time.stub!(:now).and_return(now)
  end
  describe 'HTML' do
    describe 'buid_header' do
      it 'should show the current time' do
        HtmlCsvText::HTML.new.build_header.should == "Report Generated at June 04, 2009 03:33" 
      end
    end

    describe 'build_body' do
      it 'should show the groupingin html' do
        e=HtmlCsvText::HTML.new
        e.stub_association!(:data,:to_grouping => @mock_group=['1,2,3'], :to_table => @mock_table=[1,2])
        @mock_group.should_receive(:to_html).and_return('Body in HTML')

        e.build_body.should == ('Body in HTML')
      end
    end

  end

  describe CSV do

    describe 'build_body' do
      it 'should show the table in csv' do
        e=HtmlCsvText::CSV.new
        e.stub!(:data => mock_object(:to_table=>@mock_table=mock_object))
        @mock_table.should_receive(:to_csv).and_return('Table in CSV')

        e.build_body.should == 'Table in CSV'
      end

    end


  end

  describe Text do
    describe 'buid_header' do
      it 'should show the current time' do
        HtmlCsvText::Text.new.build_header.should == "Report Generated at June 04, 2009 03:33\n\n" 
      end
    end

    describe 'build_body' do
      it 'should show the body' do
        e=HtmlCsvText::Text.new
        e.stub_association!(:data,:to_grouping => @mock_group=['1,2,3'], :to_table => @mock_table=[1,2])
        @mock_group.should_receive(:to_text).and_return('Body in Text')

        e.build_body.should == ('Body in Text')
      end


    end


  end
end
