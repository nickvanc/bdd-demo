Feature: [PA] Global cab PA

  Background: SUT and TS setup
    # define what's required to do all below test scenarios

  Scenario: [PA] Global cab PA [qual/capa] happy path
    Given the system is in idle state with default configuration
    When the driver starts a PA call from the driver desk
    Then all PA interfaces should feedback PA is on
    When starting a PA announcement from the driver desk microphone
    Then the announcement should be broadcasted to all zones except the drive desk zone
    And all PA interfaces should feedback PA is on
    When stopping the PA announcement
    Then all PA broadcasting should be stopped
    And all PA interfaces should feedback PA is on
    When the driver stops the PA call from the driver desk
    Then all PA interfaces should feedback PA is off

  Scenario: [PA] Global cab PA [qual/capa] no activity time-out
    Given the system is in idle state with default configuration
    When the driver starts a PA call from the driver desk
    And starting a PA announcement from the driver desk microphone
    When stopping the PA announcement
    And waiting for 30 seconds
    Then all PA interfaces should feedback PA is off

  Scenario: [PA] Global cab PA [qual/capa] no activity time-out without announcement
    Given the system is in idle state with default configuration
    When the driver starts a PA call from the driver desk
    And waiting for 30 seconds
    Then all PA interfaces should feedback PA is off

  Scenario: [PA] Global cab PA [qual/capa] PA on/off feedback
    Given the system is in idle state with default configuration
    When the driver starts a PA call from the driver desk
    Then the other drivers should see PA is on
    # PAD LED is on at driver desk
    And the guards should see PA is on
    # PA LED is on at all GOPs
    When the driver stops the PA call from the driver desk
    Then the other drivers should see PA is off
    # PAD LED is on at driver desk
    And the guards should see PA is off
    # PA LED is on at all GOPs

  Scenario Outline: [PA] Global cab PA [qual/capa] multiple announcements
    Given the system is in idle state with default configuration
    And the driver started a PA call from the driver desk
    When waiting for <delay> seconds
    And starting a PA announcement from the driver desk microphone
    Then the announcement should be broadcasted to all zones except the drive desk zone
    When stopping the PA announcement
    Then all PA broadcasting should be stopped

    Examples:
      | delay |
      | 5     |
      | 15    |
      | 25    |


  Scenario: [PA] Global cab PA [prod/intf/usri] verify all customer feedback signals
    Given the system is in idle state with default configuration
    When the driver starts a PA call from the driver desk
    Then all PA interfaces should feedback PA is on
    And all other LED's on the PA interfaces should remain off
    When stopping the PA call from the cab
    Then all PA interfaces should feedback PA is off
    And all other LED's on the PA interfaces should remain off


  Scenario: [PA] Global cab PA [qual/reli/robu] high network load
    Given the system is in idle state with default configuration
    And the system has high network load
    # high network= to be defined, max load where sys should operate normal
    When making a global cab PA announcement
    # underlaying steps can be nested in step definitions
    # trade-off Gherkin readibilty vs dependencies in underlaying layers
    Then the announcement should be broadcasted to all zones except the drive desk zone

  Scenario: [PA] Global cab PA [qual/reli/robu] 8 hours repeat cycle
    When starting a cyclic test with the following specifications
      | Scenario                                  | Duration | Step interval time           |
      | [PA] Global cab PA [qual/capa] happy path | 8 hours  | random between 100ms and 29s |
    Then the cyclic test should pass without problems

  Scenario: [PA] Global cab PA [qual/scal] max chain length fallback backbone
    Given the system is in fallback state for cab PA with default configuration
    And the system configuration has the maximum number of devices between the cabines
    When making a global cab PA announcement
    # underlaying steps can be nested in step definitions
    # trade-off Gherkin readabilty vs dependencies in underlaying layers
    Then the announcement should be broadcasted to all zones except the drive desk zone

  Scenario: [PA] Global cab PA [prod/func/star] test after system startup
    Given the system powers on
    # startup time should be dealed with in underlaying code
    And the system is in idle state with default configuration
    When making a global cab PA announcement
    Then the announcement should be broadcasted to all zones except the drive desk zone

  Scenario: [PA] Global cab PA [prod/func/star] 100 startup cycles
    Given a power cycle test system is in place
    When starting a cyclic test with the following specifications
      | Scenario                                  | Cycles |
      | [PA] Global cab PA [qual/capa] happy path | 100    |
    Then the cyclic test should pass without problems

  Scenario: [PA] Global cab PA [prod/func/test] traceable on logging
    Given the system is in idle state with default configuration
    When the driver starts a PA call from the driver desk
    Then the system log should have an entry
      | Message                     |
      | Driver desk PA call started |
    When starting a PA announcement from the driver desk microphone
    Then the system log should have an entry
      | Message                             |
      | Driver desk PA announcement started |
    When stopping the PA announcement
    Then the system log should have an entry
      | Message                             |
      | Driver desk PA announcement stopped |
    When stopping the PA call from the cab
    Then the system log should have an entry
      | Message                     |
      | Driver desk PA call stopped |

  Scenario: [PA] Global cab PA [prod/oper/envi] cab microphone in high noise environment
    Given the system is in idle state with default configuration
    And there is a high noise level in the active cab
    When making a global cab PA announcement
    Then the announcement should be broadcasted to all zones except the drive desk zone
    And the announcement should be understood
    # And the announcement signal should have a minimum signal-to-noise-ratio

  Scenario: [PA] Global cab PA [prod/oper/disf] abort PA before PTT
    Given the system is in idle state with default configuration
    When the driver starts a PA call from the driver desk
    Then all PA interfaces should feedback PA is on
    When stopping the PA call from the cab
    Then all PA interfaces should feedback PA is off

  Scenario: [PA] Global cab PA [prod/oper/disf] try announcement without activating PA
    Given the system is in idle state with default configuration
    When starting a PA announcement from the cab microphone
    Then the announcement shouldn't be broadcasted

  Scenario: [PA] Global cab PA [prod/oper/extr] multiple PA button pushes
    Given the system is in idle state with default configuration
    When the driver desk PA button is stressed
      | Duration |
      | 1 minute |
    # "stressed" for us this can mean timing between 10ms and 500ms
    # "normal usage" can mean timing between 500ms and ... minutes
    And making a global cab PA announcement
    Then the announcement should be broadcasted to all zones except the drive desk zone

  Scenario: [PA] Global cab PA [prod/oper/extr] multiple PTT button pushes
    Given the system is in idle state with default configuration
    When the driver starts a PA call from the driver desk
    And the driver desk PTT button is stressed
      | Duration |
      | Interval |
    And starting a PA announcement from the driver desk microphone
    Then the announcement should be broadcasted to all zones except the drive desk zone

  # First words not understood when off/on transition is too long
  # https://ux.stackexchange.com/questions/82485/whats-the-longest-acceptable-delay-before-an-interaction-starts-to-feel-unnatur
  Scenario: [PA] Global cab PA [prod/time/inpu] first words broadcasted
    Given the system is in idle state with default configuration
    When the driver starts a PA call from the driver desk
    And starting a PA announcement from the driver desk microphone
    Then the delay between PTT press and broadcasting should be below 100ms
    # 300ms is not confirmed, just an example

  Scenario: [PA] Global cab PA [prod/time/fast] apply tests sequence timings around time-outs
    Given the system is in idle state with default configuration
    When the driver starts a PA call from the driver desk
    And waiting for
      | Wait time                  |
      | random between 28s and 32s |
    When making a global cab PA announcement
    Then the announcement should be broadcasted to all zones except the drive desk zone

  Scenario: [PA] Global cab PA [prod/time/conc] while CC call is ongoing
    Given there is a CC call ongoing
    When making a global cab PA announcement
    Then the announcement should be broadcasted to all zones except the drive desk zone
    # Then step for the CC call?!

  Scenario: [PA] Global cab PA [prod/time/conc] while other cab PA is ongoing
    Given there is a other cab PA call ongoing
    When the driver starts a PA call from the driver desk
    Then the PA call start request should be rejected

  Scenario: [PA] Global cab PA [prod/time/conc] while saloon PA call is ongoing
    Given there is a saloon PA call ongoing
    When making a global cab PA announcement
    Then the announcement should be broadcasted to all zones except the drive desk zone
    # Then step for the saloon PA call?!

  Scenario: [PA] Global cab PA [prod/time/conc] while train radio PA call is ongoing
    Given there is a train radio PA call ongoing
    When the driver starts a PA call from the driver desk
    Then the PA call start request should be rejected
