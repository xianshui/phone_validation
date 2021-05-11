Feature: Validate
  The validater should show result after inputting number and tap validate

  Scenario: Validater show result after inputting number and tap validate
    Given I have "phone_number" and "validate" and "status"
    When I fill the "phone_number" field with "18038123871"
    And I tap the "validate" button
    Then I expect the "status" to be "Phone number is invalid"
