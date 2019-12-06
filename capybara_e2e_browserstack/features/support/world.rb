module ConverseAdmin

    class Actor
        include Capybara::DSL
        include RSpec::Matchers

        attr_accessor :login_name, :profile

        def initialize(options={})
           @login_name = options[:login_name] || 'James'
           @profile = options[:profile] || 'super_admin'

        end

        def performs(task)
            self
        end
        
        def asks(question)
            self
        end

        def self.super_admin
            Actor.new({login_name: 'James', profile: 'super_admin'})
        end
        
        def self.admin
            Actor.new({login_name: 'John', profile: 'admin'})
        end

        def self.user
            Actor.new({login_name: 'James', profile: 'user'})
        end

        def is_bot_deleted(bot_name)
            expect(page).to have_content("Bot #{bot_name} has been deleted!", wait:3) 
        end

        def at_the_library_management
            find("a[href='#/libraries']").click
        end

        def at_the_intent_management
            find("a[href='#/intents']").click
        end

        def create_new_library(library, type)
            find('textarea[data-qa="library-name-input"]').send_keys(library)
            select_library(type)
            find('button[data-qa="modal-create-library-button"]').click
        end

        def select_library(library_type)
            case library_type
            when 'Shared Library'
                if(page.has_selector?("[data-qa='shared-library-radio']"))
                   find(:id, "shared").click
                #  find('button[data-qa="shared-library-radio"]').click
                
                end
            when 'Private Library'
                if(page.has_selector?("[data-qa='private-library-radio']"))
                    find(:id, "private").click
                end
            end
        end

        def add_library(from, library, library_type)
            case from
            when 'Intent Tab'
                at_the_intent_management
                find('button[data-qa="create-library-button"]').click
                
            when 'Libraries Tab'
                at_the_library_management
                #Blocked by IC-1728
            end

            create_new_library(library, library_type)
        end

        def add_library_to_bot(library, bot_name)
            fill_in 'Search for Libraries', with: library
            #Blocked by IC-1728
           # find("button", :text => /^Add$/).click
        end

        def delete_library(library, library_remove_locator)
            at_the_library_management
            find(library_remove_locator).click
        end


        def at_the_intent_management
            find("a[href='#/enquiry']").click
        end

        def logout
            click_on(id: 'account-menu')
            find(:id, "logout").click
        end
    end

    class Tasks
        include Capybara::DSL
        include RSpec::Matchers

        def open_converse_admin_url_page
            visit(ENV['environ'] )
        end
  
        def open_sign_in
            find('span.ng-scope', text: '/^Account/$').click
            click_on(id: 'login')
        end

        def sign_in_with_username_and_password(username, password)
            if page.has_selector?(:id, 'username')
                fill_in('username', with: username)
            end
            if page.has_selector?(:id, 'password')
                fill_in('password', with: password)
            end
            if page.has_selector?(:id, 'rememberMe')
                check 'rememberMe'
            end

            find("button", :text => /^Sign in$/).click
           # self
        end

        def login_as_super_admin
            puts 'login as super admin'
            sign_in_with_username_and_password('admin', 'admin')
        end

        def login_as_user
            sign_in_with_username_and_password('user', 'user')
        end

        def at_the_main_dashboard
            open_converse_admin_url_page
            sign_in_with_username_and_password('admin', 'admin')
        end
        
        def at_the_user_management
            click_on(id: 'account-menu')
            find("a[href='#/admin']").click
        end

        def create_new_user
            find('button[data-qa="create-new-user"]').click
        end

        def create_new_user_account(login, first_name, email, role)
            create_new_user
            fill_in('login', with: login)
            fill_in('firstName', with: first_name)
            fill_in('email', with: email)
            case role
            when 'user'
                find("option[value='string:ROLE_USER']").click
            else
                find("option[value='string:ROLE_ADMIN']").click
            end
        end

        def save_user_account
            find('button[data-qa="save-user-button"]').click
        end

        def select_2FA
            find(:id, "two-fa").set(true)
        end

        def did_not_fill_up_required_fields(fields)
            field = fields.split(",")
            login = field[0]
            first_name = field[1]
            if(page.has_selector?("[data-qa='login-input']"))
             fill_in('login', with: login)
            end
            if(page.has_selector?("[data-qa='first-name-input']"))
             fill_in('firstName', with: first_name)
            end
        end
    
        def setup_account(account)
            first_name = "john"
            role = "user"
            login = account.split(",")[0]
            email = account.split(",")[1]
            at_the_user_management
            create_new_user_account(login, first_name, email, role)
            save_user_account
            new_user_account_created(login, first_name, email, role)
        end

        def edit_field(field, account)
            login = account.split(",")[0]
            email = account.split(",")[1]
           # select_dropdown = login + "-action-dropdown"
            # IC-1728 to added locator to be done by frontend developer
            select_edit = login + "-edit-button"
            #if page.has_css?("button[data-qa='#{select_dropdown}']") 
            #    find("button[data-qa='#{select_dropdown}']").click
            #end
            action_dropdown(account)

           # if page.has_css?("button[data-qa='#{select_edit}']") 
            #    find("button[data-qa='#{select_edit}']").click
           # end

           find("button", :text => /^Edit$/).click
            case field
            when 'login'
                if(page.has_selector?("[data-qa='login-input']"))
                    fill_in('login', with: field)
                end
            when 'first_name'
                if(page.has_selector?("[data-qa='first-name-input']"))
                    fill_in('firstName', with: field)
                end
            when 'last_name'
                if(page.has_selector?("[data-qa='last-name-input']"))
                    fill_in('lastName', with: field)
                end
            when 'email'
                if(page.has_selector?("[data-qa='email-input']"))
                    fill_in('email', with: field)
                end
            end
        
          #  @james.save_user_account
        end

        def update_edited_field(field, account)
           

        end

        def able_to_view_details_user_account(account)

        end

        def send_set_password_email(account)
            action_dropdown(account)
            find("button", :text => /^Send Set Password Email$/).click
        end

        def is_able_to_send_email 
        end

        def deactivate_user_account(account)
            action_dropdown(account)
            find("button", :text => /^Deactivate Account$/).click
            find("button", :text => /^Yes$/).click
           
        end

       

        def activate_user_account(account)

        end

        def is_account_activated(account)

        end

        def action_dropdown(account)
            login = account.split(",")[0]
            select_dropdown = login + "-action-dropdown"
            find("button[data-qa='#{select_dropdown}']").click
            
        end

        def delete_user_account(account)
            login = account.split(",")[0]
            select_delete = login + "-delete-button"
            action_dropdown(account)
            find("button[data-qa='#{select_delete}']").click
            find("button[data-qa='confirm-delete-user']").click
        end

       
        def cancel_create_user_account
            find("button[data-qa='cancel-user-button']").click
        end

        def deactivated_user_account_attempt_to_sign_in(account)
            login = account.split(",")[0]
            email = account.split(",")[1]
            password = login.split("@")[0]
            open_sign_in
            sign_in_with_username_and_password(login, password)
        end
        
       
        def at_the_bot_management
            find("a[href='#/bots']").click
        end

        def create_new_bot(bot_name)
            find('button[data-qa="create-new-bot"]').click
            find('textarea[data-qa="bot-name-input"]').send_keys(bot_name)
            find('button[data-qa="create-bot-button"]').click
        end

      
        def delete_bot(bot_name, bot_name_remove_locator)
            at_the_bot_management
            find(bot_name_remove_locator).click
            find('button[data-qa="confirm-remove-button"]').click
        end
    end


    class Questions

        include Capybara::DSL
        include RSpec::Matchers

        def is_able_to_login_as_username(username)
            case username
            when 'admin'
                expect(page).to have_content('Super Admin A.')
            else
                expect(page).to have_content('User U.')
            end
        end

        def is_unable_to_login_as_username(username)
           # expect(page).to have_content('Failed to sign in!')
           expect(page).to have_selector('.alert', text: 'Invalid username or password') 
        end

        def has_full_access
            expect(page).to have_content('User management')
            expect(page).to have_content('Settings')
            expect(page).to have_content('Password')
            expect(page).to have_content('2FA Setup')
            expect(page).to have_content('Intents')
            expect(page).to have_content('Reporting')
            expect(page).to have_content('Analytics')
            expect(page).to have_content('Ontology')
            expect(page).to have_content('Libraries')
            expect(page).to have_content('Bots')
            expect(page).to have_content('Unhandled Phrases')
        end

        def has_limited_access
            expect(page).to have_content('User management')
            expect(page).to have_content('Settings')
            expect(page).to have_content('Password')
            expect(page).to have_content('2FA Setup')
            expect(page).to have_content('Intents')
            expect(page).to have_content('Reporting')
            expect(page).to have_content('Analytics')
            expect(page).to have_content('Ontology')
            expect(page).to have_content('Libraries')
            expect(page).to have_content('Bots')
            expect(page).to have_content('Unhandled Phrases')
        end
    
        def has_no_access
            expect(page).not_to have_content('User management')
            expect(page).to have_content('Settings')
            expect(page).to have_content('Password')
            expect(page).to have_content('2FA Setup')
            expect(page).to have_content('Intents')
            expect(page).to have_content('Reporting')
            expect(page).to have_content('Analytics')
            expect(page).to have_content('Ontology')
            expect(page).not_to have_content('Libraries')
            expect(page).not_to have_content('Bots')
            expect(page).to have_content('Unhandled Phrases')
        end

        def new_user_account_created(login, first_name, email, role)
            expect(page).to have_content(login)
            expect(page).to have_content(first_name)
            expect(page).to have_content(email)
            case role
            when 'admin'
                expect(page).to have_content('ROLE_ADMIN')
            else
                expect(page).to have_content('ROLE_USER')
            end
        end

        def deactivated_account_unable_to_login
            #Error message should be this account is deactivated
            #IC-1745
            expect(page).to have_selector('.alert', text: 'Invalid username or password') 
        end
        def unable_to_save_user_account
            expect(page.has_css?("button[disabled='disabled']"))
        end

        def is_account_deactivated(account)
            expect(page).to have_content("Account has been deactivated!", wait:3) 
            # find('td', text: login ).should have_content('Deactivated')
        end
        
        def is_account_deleted(account)
            login = account.split(",")[0]
            email = account.split(",")[1] 
            within "[data-qa='users-table']" do
                expect(page).not_to have_content(login)
                expect(page).not_to have_content(email)
            end
        end

        def is_unable_to_create_user_account_with_login_already_in_use
            expect(page).to have_selector('.alert', text: 'Login already in use') 
        end

        def is_unable_to_create_user_account_with_email_already_in_use
            expect(page).to have_selector('.alert', text: 'Email already in use') 
        end


        def is_library_created(library)
            expect(page).to have_content("Library #{library} has been created", wait:3) 
        end

        def is_bot_created(bot_name)
            expect(page).to have_content("Bot #{bot_name} has been created!", wait:3) 
        end
       

        def is_library_deleted(library)
            expect(page).to have_content("Library #{library} has been deleted!", wait:3) 
        end

    end

    def super_admin
        @super_admin ||= Actor.super_admin
    end
   
    def admin
        @admin ||= Actor.admin
    end
    
    def user
        @user ||= Actor.user
    end

    def question_to_ask
        @question ||= Questions.new
    end

    def task_to_perform
        @task ||= Tasks.new
    end
end

World(ConverseAdmin)


