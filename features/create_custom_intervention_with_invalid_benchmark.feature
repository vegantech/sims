Feature: Test saving custom intervention with custom probe and invalid benchmark
  
  Scenario: custom_probe_with_benchmark_out_of_range
    Given load demo data 
    And Create Custom Probe
    Then it should not save
    And it should save when fixed

