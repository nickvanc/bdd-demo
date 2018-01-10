Feature: [PA] Train radio PA

  Scenario: [PA] Train radio PA [qual/capa] happy path
    Given the system is in idle state with default configuration
    When the OCC starts a PA call from the radio
    #there's no visual feedback train radio PA is on
    Then all PA interfaces should feedback PA is off
    When starting a PA announcement from the radio
    Then the announcement should be broadcasted to all zones
    When stopping the PA announcement
    Then all PA broadcasting should be stopped
    When the OCC stops the PA call from the radio
    Then all PA interfaces should feedback PA is off