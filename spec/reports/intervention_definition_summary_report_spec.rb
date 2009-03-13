require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InterventionDefinitionSummaryReport do
  describe 'render_text' do
    it 'should generate correct text output' do
      ic = Factory(:intervention_cluster, :title => 'IC-TITLE')
      id = Factory(:intervention_definition, :title => 'ID-TITLE', :intervention_cluster => ic)
      od = ic.objective_definition
      
      Time.stub!(:now => Date.new(2008, 12, 12).to_time)

      report_body = InterventionDefinitionSummaryReport.render_text(:objective_definition => od.id)

      report_body.should == <<EOS
Report Generated at December 12, 2008 00:00

 - Some tier:

+--------------------------------------------------------------------------------------------------------------------------------+
| Bus. Key | Category |      Title      |     Description     | Duration / Frequency | Progress Monitors | Links and Attachments |
+--------------------------------------------------------------------------------------------------------------------------------+
| -1-1-1-1 | IC-TITLE | <b>ID-TITLE</b> | ID-TITLEDescription | 1 Default / 1 time   |                   |                       |
+--------------------------------------------------------------------------------------------------------------------------------+

EOS
    end
  end
end
