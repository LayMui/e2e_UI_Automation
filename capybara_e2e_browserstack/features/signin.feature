Feature: signin
    In order to perform authentication to access the converse system
    As a user based on the role given
    I want to sign in

  Background:
    Given James is at the converse admin url page
 
@run
  Scenario Outline: Sign in with valid credentials
     In order to login to the converse system
     As a user based on the role given
     James wants to login with valid credentials
     When James sign in with username = "<username>" and password = "<password>"
     Then James is able to login as username = "<username>"

    Examples:
      | username | password |
      | admin | admin |  
      | user | user |  

  Scenario Outline: Cannot sign in with invalid credentials
     In order to validate login to the converse system
        As a bot admin user James
        James is not allowed to login with invalid credentials
     When James sign in with username = "<username>" and password = "<password>"
     Then James is unable to login as username = "<username>"

    Examples:
      | username | password |
      | admin | admin123 |  
      | admin123 | admin |  
      | admin123 | admin123 |  
      | user | user123 |  
      | user123 | user |  
      | user123 | user123 |  
