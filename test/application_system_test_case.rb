require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :browserstack

  def self.start_application
    # ignore no need to start local server
  end
end
