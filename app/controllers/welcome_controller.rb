class WelcomeController < ApplicationController
  def index
    require "pry-nav"; binding.pry
    session = Capybara::Session.new(:selenium_chrome_headless)
    @heise = session.visit("www.heise.de")
    @heise
  end
end
