@block @block_my_feedback
Feature: Student feedback hides coursework marker identity when assessor anonymity is enabled
  In order to protect anonymous marking in coursework
  As a student
  I should not see the marker identity in My feedback when assessor anonymity is enabled

  Background:
    Given the following "courses" exist:
      | fullname | shortname | category |
      | Course 1 | C1        | 0        |
    And the following "users" exist:
      | username | firstname | lastname | email                |
      | teacher1 | Teacher   | 1        | teacher1@example.com |
      | student1 | Student   | 1        | student1@example.com |
    And the following "course enrolments" exist:
      | user     | course | role    |
      | teacher1 | C1     | teacher |
      | student1 | C1     | student |
    And the following "blocks" exist:
      | blockname   | contextlevel | reference | pagetypepattern | defaultregion | defaultweight |
      | my_feedback | system       |           | my-index        | content       | 0             |

  @skip_if_component_missing_mod_coursework
  Scenario: Student does not see coursework marker identity when assessor anonymity is enabled
    Given the following "activity" exists:
      | activity           | coursework        |
      | course             | C1                |
      | name               | Test coursework   |
      | assessment_type    | 1                 |
      | deadline           | ##tomorrow##      |
      | assessoranonymity  | 1                 |
    And I create a grade item for "coursework" activity "Test coursework" in course "C1" named "Test coursework"
    And I create a grade for user "student1" in "coursework" activity "Test coursework" in course "C1" graded by "teacher1"
    When I am logged in as "student1"
    And I follow "Dashboard"
    Then "My feedback" "block" should exist
    And I should see "Test coursework" in the "My feedback" "block"
    But I should not see "Teacher 1" in the "My feedback" "block"

  @skip_if_component_missing_mod_coursework
  Scenario: Student sees coursework marker identity when assessor anonymity is disabled
    Given the following "activity" exists:
      | activity           | coursework        |
      | course             | C1                |
      | name               | Test coursework   |
      | assessment_type    | 1                 |
      | deadline           | ##tomorrow##      |
      | assessoranonymity  | 0                 |
    And I create a grade item for "coursework" activity "Test coursework" in course "C1" named "Test coursework"
    And I create a grade for user "student1" in "coursework" activity "Test coursework" in course "C1" graded by "teacher1"
    When I am logged in as "student1"
    And I follow "Dashboard"
    Then "My feedback" "block" should exist
    And I should see "Test coursework" in the "My feedback" "block"
    And I should see "Teacher 1" in the "My feedback" "block"
