# frozen_string_literal: true

require "capybara_helper"

describe "Events", type: :system do
  it "overview page" do
    event = FactoryBot.create :event

    visit "/"
    click_on "Events"

    expect(page).to have_text "All events"
    expect(page).to have_table_with_exact_data([
      ["Date", "Name", "State", ""],
      [event.done_at.strftime("%d.%m.%Y %H:%M"), "google", "ok", "show"]
    ])
  end

  it "creates a new station" do
    event = FactoryBot.create :event

    visit "/"
    click_on "Events"
    click_on "show"

    expect(page).to have_text "Event: google"
    expect(page).to have_text "ok"
    expect(page).to have_text event.done_at.strftime("%d.%m.%Y %H:%M")
  end
end