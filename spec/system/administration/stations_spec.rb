# frozen_string_literal: true

require "capybara_helper"

describe "Stations", type: :system do
  # before     { perform_login_as mock_employee_person }

  it "overview page" do
    FactoryBot.create :station
    visit "/"
    click_on "Stations"
    expect(page).to have_text "Stations Overview"
  end
end
