# frozen_string_literal: true

require "rails_helper"

RSpec.configure do |config|
  config.include Capybara::RSpecMatchers

  Capybara.default_max_wait_time = 10 # The maximum number of seconds to wait for asynchronous processes to finish.
  Capybara.default_normalize_ws = true # match DOM Elements with text spanning over multiple line

  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    # https://api.rubyonrails.org/v6.0.1/classes/ActionDispatch/SystemTestCase.html#method-c-driven_by
    browser = ENV["SELENIUM_BROWSER"].presence&.to_sym || :headless_chrome
    driven_by :selenium, using: browser, screen_size: [1600, 1400]
  end
end
