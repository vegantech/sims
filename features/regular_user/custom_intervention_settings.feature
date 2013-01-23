Feature: Custom Intervention Settings
  In order to use custom interventions
  An Intervention
  Should follow the district custom settings

	Scenario: Display or Hide the Custom Intervention Link
		Given I am at the student profile page
		When I reload based on the following table:
			| setting        | content_admin? | display? |
			|                | false          | true     |
			| only_author    | false          | true     |
			| content_admins | false          | false    |
			| content_admins | true           | true     |
			| disabled       | false          | false    |
			| disabled       | true           | false    |
			| one_off        | true           | true     |
			| one_off        | false          | true     |


	Scenario: Include or exclude custom interventions based on settings
		Given I am at the student profile page
		And a single intervention category
		And an assortment of custom interventions
		Then I start a new intervention based on the following table:
			| setting        | intervention                    | display? |
			|                | same_user_same_school           | true     |
			|                | different_user_same_school      | true     |
			|                | same_user_different_school      | true     |
			|                | different_user_different_school | false    |
			| disabled       | same_user_same_school           | true     |
			| disabled       | different_user_same_school      | false    |
			| disabled       | same_user_different_school      | true     |
			| disabled       | different_user_different_school | false    |
			| content_admins | same_user_same_school           | true     |
			| content_admins | different_user_same_school      | true     |
			| content_admins | same_user_different_school      | true     |
			| content_admins | different_user_different_school | false    |
			| only_author    | same_user_same_school           | true     |
			| only_author    | different_user_same_school      | false    |
			| only_author    | same_user_different_school      | true     |
			| only_author    | different_user_different_school | false    |
			| one_off        | same_user_same_school           | false    |
			| one_off        | different_user_same_school      | false    |
			| one_off        | same_user_different_school      | false    |
			| one_off        | different_user_different_school | false    |
