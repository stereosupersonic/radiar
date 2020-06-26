# frozen_string_literal: true

require "capybara_helper"

describe "welcome", type: :system do
  it "shows the welcome page" do
    visit "/"

    expect(page).to have_content("Welcome")
  end
end
