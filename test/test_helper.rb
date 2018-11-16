ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

# monkey patch to avoid reset sessions
class Capybara::Selenium::Driver < Capybara::Driver::Base
  def reset!
    if @browser
      @browser.navigate.to('about:blank')
    end
  end
end

TASK_ID = (ENV['TASK_ID'] || 0).to_i

CONFIG = YAML.load(File.read(Rails.root.join("config", "browserstack.yml")))
CONFIG['user'] = ENV['BROWSERSTACK_USERNAME'] || CONFIG['user']
CONFIG['key'] = ENV['BROWSERSTACK_ACCESS_KEY'] || CONFIG['key']


Capybara.register_driver :browserstack do |app|
  @caps = CONFIG['common_caps'].merge(CONFIG['browser_caps'][TASK_ID])

  # Code to start browserstack local before start of test
  if @caps['browserstack.local'] && @caps['browserstack.local'].to_s == 'true';
    @bs_local = BrowserStack::Local.new
    bs_local_args = {"key" => "#{CONFIG['key']}"}
    @bs_local.start(bs_local_args)
  end

  Capybara::Selenium::Driver.new(app,
    :browser => :remote,
    :url => "http://#{CONFIG['user']}:#{CONFIG['key']}@#{CONFIG['server']}/wd/hub",
    :desired_capabilities => @caps
  )
end

Capybara.default_driver = :browserstack

# Code to stop browserstack local after end of test
at_exit do
  @bs_local.stop unless @bs_local.nil? 
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
