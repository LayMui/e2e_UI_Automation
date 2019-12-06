require 'capybara/cucumber'
require 'capybara/poltergeist'
require 'selenium-webdriver'
require 'rspec/expectations'
require 'capybara'
require 'capybara/dsl'
require 'yaml'
require 'browserstack/local'

if ENV['chrome']
    Capybara.default_driver=:selenium_chrome
elsif ENV['firefox']
    Capybara.default_driver=:selenium  #selenium driving firefox
elsif ENV['chrome_headless']
    Capybara.default_driver=:selenium_chrome_headless #selenium driving chrome_headless
elsif ENV['firefox_headless']
    Capybara.default_driver=:selenium_headless #selenium driving firefox headless
elsif ENV['browserstack']
    # monkey patch to avoid reset sessions
  class Capybara::Selenium::Driver < Capybara::Driver::Base
    def reset!
      @browser.navigate.to('about:blank') if @browser
    end
  end
  
  TASK_ID = (ENV['TASK_ID'] || 0).to_i
  CONFIG_NAME = ENV['CONFIG_NAME'] || 'single'
  #capabilities['browser_version'] = ENV['SELENIUM_VERSION'] if ENV['SELENIUM_VERSION']
  
  CONFIG = YAML.safe_load(File.read(File.join(File.dirname(__FILE__), "../../config/#{CONFIG_NAME}.config.yml")))
  CONFIG['user'] = ENV['BROWSERSTACK_USERNAME'] || CONFIG['user']
  CONFIG['key'] = ENV['BROWSERSTACK_ACCESS_KEY'] || CONFIG['key']
  
  Capybara.register_driver :browserstack do |app|
    @caps = CONFIG['common_caps'].merge(CONFIG['browser_caps'][TASK_ID])
    
    # Code to start browserstack local before start of test
    if @caps['browserstack.local'] && @caps['browserstack.local'].to_s == 'true'
      @bs_local = BrowserStack::Local.new
      bs_local_args = { 'key' => (CONFIG['key']).to_s, 'forcelocal' => 'true' }
      @bs_local.start(bs_local_args)
    end
  
    
    Capybara::Selenium::Driver.new(app,
                                   browser: :remote,
                                   url: "https://#{CONFIG['user']}:#{CONFIG['key']}@#{CONFIG['server']}/wd/hub",
                                   desired_capabilities: @caps)

                                #   url = "http://#{ENV['BROWSERSTACK_USERNAME']}:#{ENV['BROWSERSTACK_ACCESS_KEY']}@hub-cloud.browserstack.com/wd/hub"

    end

  
  Capybara.default_driver = :browserstack
  Capybara.run_server = false
  
  # Code to stop browserstack local after end of test
  at_exit do
    @bs_local.stop unless @bs_local.nil?
  end
else
    Capybara.register_driver :selenium do |app|

        arguments = ["headless","disable-gpu", "no-sandbox", "window-size=1920,1080", "privileged", "remote-debugging-port=9222"]
        preferences = {
            'download.prompt_for_download': false,
        }
        options = Selenium::WebDriver::Chrome::Options.new(args: arguments, prefs: preferences)
        Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
        Capybara.run_server = false
        Capybara.default_driver = :selenium
        Capybara.javascript_driver = :selenium
        Capybara.default_selector = :css
    end
    puts "running on browser: chrome"
end

  Capybara.run_server = false
  Capybara.default_max_wait_time = 10
  #Capybara.save_path = '/tmp/capybara'
 
World(Capybara::DSL)



