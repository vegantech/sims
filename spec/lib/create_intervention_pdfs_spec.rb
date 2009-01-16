require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CreateInterventionPdfs do
  describe 'generate class method' do
    describe 'passed a valid district' do

      describe 'with objective_definitions' do
        it 'should write a PDF, and HTML report for each objective_definition' do
          od = mock_objective_definition(:title => 'some objective definition')
          district = mock_district(:objective_definitions => [od])
          InterventionDefinitionSummaryReport.should_receive(:render_pdf).with( :objective_definition => od, :template => :standard).and_return('PDF Contents')
          InterventionDefinitionSummaryReport.should_receive(:render_html).with(:objective_definition => od, :template => :standard).and_return('HTML Contents')

          CreateInterventionPdfs.generate(district)

          district_dir = "#{RAILS_ROOT}/public/district_generated_docs/#{district.id}"
          root_file_name = "#{district_dir}/some_objective_definition"
          File.read("#{root_file_name}.pdf").should  == 'PDF Contents'
          File.read("#{root_file_name}.html").should == 'HTML Contents'
          FileUtils.rm_r(district_dir)
        end
      end

      describe 'without ojbective_definitions' do
        it 'should write a PDF, and HTML report for each objective_definition' do
          district = mock_district(:objective_definitions => [])
          FileUtils.should_not_receive(:mkdir_p)

          CreateInterventionPdfs.generate(district)
        end
      end
    end
  end
end