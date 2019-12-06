Given /^James is at the converse admin url page$/ do
   @james = super_admin
   @task = task_to_perform
   @james.performs(@task.open_converse_admin_url_page)
end

When /^James sign in with username = "(.*)" and password = "(.*)"$/ do |username, password|
   @james.performs(@task.sign_in_with_username_and_password(username, password))
end

Then /^James is able to login as username = "(.*)"$/ do |username|
   @question = question_to_ask
   @james.asks(@question.is_able_to_login_as_username(username))
end

Then /^James is unable to login as username = "(.*)"$/  do |username|
   @james.asks(@question.is_unable_to_login_as_username(username))
end
