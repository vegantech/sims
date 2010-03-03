Feature: Progress Monitor Builder
  In order to create a new progress monitor
  A content builder user
  Should be able to create a Progress Monitorhierarchy for the intervention definition

  Scenario: Spellcheck with new attachment [#246]
    Given I log in as content_builder
    And I follow "Progress Monitor Builder"
    
    When I follow "Create New Progress Monitor"
    And I fill in "Title" with "test_spellcheck_with_attachment"
    And I fill in "Description" with "test_spellcheck_with_attachment"
    And I attach the file "README" to "probe_definition_new_asset_attributes__document"
    And I am pending until webrat bug in ticket 198 (on webrat lighthouse) is fixed
    When I press "Create"
    Then I should see "README"
    And I am pending until I can figure out why attach_file behavior differs from browser




    And I press "Spellcheck"
    Then I should see "README"
    


