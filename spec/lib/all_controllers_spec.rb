require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AllControllers do
  describe 'names class method' do
    # NOTE: The names should be generated dynamically
    # For now, I'm just testing that the correct list of names are returned,
    # combined with the knowledge that the code is written to behave dynamically.
    # If you want to change this test to prove that the code is dynamic, be my guest...
    it 'should list all controller names' do
      # For now I'm testing this is strictly equal.
      # Once we trust it, we could use subset? instead to keep it from breaking ALL the time...
      AllControllers.names.should == %w{
        checklist_builder/answers checklist_builder/checklists checklist_builder/elements checklist_builder/questions
        checklists countries custom_flags districts enrollments frequencies groups ignore_flags
        intervention_builder/categories intervention_builder/goals intervention_builder/interventions intervention_builder/objectives
        intervention_builder/probes intervention_builder/recommended_monitors
        interventions/categories interventions/comments interventions/definitions interventions/goals interventions/objectives interventions/participants 
        interventions/probe_assignments interventions/probes
        interventions login main principal_overrides probe_questions recommendations reports roles schools states student_comments students
        tiers users
      }
    end
  end
end
