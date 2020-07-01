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
      ["Time", "Song", "Artist", "Album", "Year", "Tag", "Video", "Station"],
      [played_at.strftime("%d.%m.%Y %H:%M"), "Once",
       "Liam Gallagher", "Once", "2019", "rock", "youtube", "Marilu"]
    ])
  end
end
