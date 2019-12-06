


# Teardown 
After('@user_account') do 
   @james = super_admin
   @james.delete_user_account("john@taiger.com, john@taiger.com")
end

After('@admin_account') do 
    @james = super_admin
    @james.delete_user_account("mary@taiger.com, mary@taiger.com")
 end

 After('@user_account_already_in_use') do
   @james.delete_user_account("john, john@taiger.com")
 end

 After('@user_account_deactivated') do
  @james.sign_in_with_username_and_password('admin', 'admin')
  @james.at_the_user_management
  @james.delete_user_account("john_taiger_test@yopmail.com, john_taiger_test@YOPmail.com")
end
 
After('@bot') do
  bot_name = "monkey"
  fmt = 'button[data-qa="%s remove"]'
  bot_name_remove_locator = fmt % [bot_name]
  @james.delete_bot(bot_name, bot_name_remove_locator)
end
 
After('@lib') do
  library= "foodlist"
  fmt = 'button[data-qa="%s remove"]'
  library_remove_locator = fmt % [bot_name]
  @james.delete_library(library, library_remove_locator)
end