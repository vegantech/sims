require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "InterventionDefinitionSummaryReport" do
  describe 'render_text' do
    it 'should generate correct text output' do
      pending 'move this to cucumber feature'
      ic = Factory(:intervention_cluster, title: 'IC-TITLE')
      id = Factory(:intervention_definition, title: 'ID-TITLE', description: "ID-DESCRIPTION", intervention_cluster: ic)
      od = ic.objective_definition
      Tier.update_all("position = 1")
      
      Time.stub!(now: Date.new(2008, 12, 12).to_time)

      report_body = InterventionDefinitionSummaryReport.render_text(objective_definition: od.id)

      report_body.should == <<EOS
Report Generated at December 12, 2008 00:00

1 - Some tier:

+-------------------------------------------------------------------------------------------------------------------------------------+
| Bus. Key  | Category |      Title      |  Description   |     Duration / Frequency      | Progress Monitors | Links and Attachments |
+-------------------------------------------------------------------------------------------------------------------------------------+
| 1-1-1-1-1 | IC-TITLE | <b>ID-TITLE</b> | ID-DESCRIPTION | 1 Default / 1 time Freq Title |                   |                       |
+-------------------------------------------------------------------------------------------------------------------------------------+

EOS
    end

    it 'should render just the date when there are no interventions ' do
      pending 'move this to cucumber feature'
      ic = Factory(:intervention_cluster, title: 'IC-TITLE')
      od = ic.objective_definition
      
      Time.stub!(now: Date.new(2008, 12, 12).to_time)

      report_body = InterventionDefinitionSummaryReport.render_text(objective_definition: od.id)
      report_body.should == "Report Generated at December 12, 2008 00:00\n\n"

    end
  end
end
