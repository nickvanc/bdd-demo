Feature: [PA] Zoned cab PA

  Scenario: [PA] Zoned cab PA [qual/capa] happy path
    Given the system is in idle state with default configuration
    When the driver selects a PA zone from the driver desk
    And the driver starts a PA call from the driver desk
    Then all PA interfaces should feedback PA is on
    When starting a PA announcement from the driver desk microphone
    Then the announcement should be broadcasted to all selected zones except the drive desk zone
    And all PA interfaces should feedback PA is on
    When stopping the PA announcement
    Then all PA broadcasting should be stopped
    And all PA interfaces should feedback PA is on
    When stopping the PA call from the cab
    Then all PA interfaces should feedback PA is off

    # Acceptance test spec says the test is repeated for all cabs


