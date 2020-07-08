# frozen_string_literal: true

require "capybara_helper"

describe "welcome", type: :system do
  it "shows the last tracks" do
    played_at = Time.current
    track = FactoryBot.create :track, played_at: played_at
    FactoryBot.create :track_info, track: track
    visit "/"

    expect(page).to have_content("Tracks")

    expect(page).to have_table_with_exact_data([
      ["Time", "Song", "Artist", "Album", "Year", "Tag", "Video", "Events", "Station"],
      [played_at.strftime("%d.%m.%Y %H:%M"), "Once",
       "Liam Gallagher", "Once", "2019", "Rock", "youtube", "events", "Marilu"]
    ])
  end

  it "shows the events" do
    played_at = Time.current
    track = FactoryBot.create :track, played_at: played_at
    event = FactoryBot.create :event, track: track
    FactoryBot.create :event
    FactoryBot.create :track_info, track: track
    visit "/"

    expect(page).to have_content("Tracks")

    click_on :events

    expect(page).to have_content("Events for Liam Gallagher - Once")
    expect(page).to have_table_with_exact_data([
      ["Date", "Name", "State", ""],
      [event.done_at.strftime("%d.%m.%Y %H:%M"), "google", "ok", "show"]
    ])

    click_on :show
    expect(page).to have_text "Event: google"
    expect(page).to have_text "ok"
    expect(page).to have_text event.done_at.strftime("%d.%m.%Y %H:%M")
    expect(page).to have_content("Liam Gallagher - Once")
  end
end
