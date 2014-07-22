require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "UserInterventionsReport" do
  describe 'render_text' do
    it 'should generate correct text output' do
      pending "move this to cucumber"
      now = Date.new(2008, 12, 12).to_time(:utc)
      Time.stub!(now: now)

      ip = Factory(:intervention_participant, role: 1)
      ip.intervention.intervention_definition.title = 'Intervention Title'
      ip.intervention.intervention_definition.save!

      report_body = UserInterventionsReport.render_text(user: ip.user) # , :start_date => start_date, :end_date => end_date, :school => school)

      report_body.should == <<EOS
Report Generated at December 12, 2008 00:00

First Last:

+--------------------------------------------------------------------------------------------------------+
|   Title / Status    |    Role     | Start Date |  End Date  |     Frequency     | Time Length | Active |
+--------------------------------------------------------------------------------------------------------+
| Intervention Title  | Participant | 2008-11-01 | 2008-12-01 | 1 time Freq Title | 1 Default   | true   |
+--------------------------------------------------------------------------------------------------------+

EOS
    end
  end
end
