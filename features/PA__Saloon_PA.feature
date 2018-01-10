Feature: [PA] Saloon PA

  Scenario: [PA] Saloon PA [qual/capa] happy path
    Given the system is in idle state with default configuration
    When the guard starts a PA call from a GOP
    Then all GOP PA interfaces should feedback PA is on
    When starting a PA announcement from the GOP microphone
    Then the announcement should be broadcasted to all saloon zones
    And all GOP PA interfaces should feedback PA is on
    When stopping the PA announcement
    Then all PA broadcasting should be stopped
    And all GOP PA interfaces should feedback PA is on
    # stop by PA btn press (can stop by hooking handset)
    When the guard stops the PA call from the GOP
    Then all PA interfaces should feedback PA is off

  Scenario: [PA] Global cab PA [qual/capa] time-out
    Given the system is in idle state with default configuration
    When the guard starts a PA call from a GOP
    And starting a PA announcement from the GOP microphone
    When stopping the PA announcement
    And waiting for 30 seconds
    Then all PA interfaces should feedback PA is off
    And all GOP PA interfaces should feedback PA is on