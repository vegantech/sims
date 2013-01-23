Feature: Intervention Builder
	In order to measure progress
	A content builder user
	Should be able to assign progress monitors to an intervention


	Scenario: Assign no recommendations
		Given I log in as content_builder
		And there is an intervention_definition that is "enabled" and "system"

		And I follow "Intervention Builder"
		And I follow "See Objectives"
		And I follow "See Categories"
		And I follow "See Interventions"
		And I follow "Recommend Progress Monitors"
		When I press "Save changes"
