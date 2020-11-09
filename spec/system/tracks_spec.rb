# frozen_string_literal: true

require "capybara_helper"

describe "show tracks", type: :system do
  it "shows the last tracks" do
    played_at = Time.current.strftime("%d.%m.%Y %H:%M")
    track = FactoryBot.create :track, played_at: played_at
    FactoryBot.create :track_info, track: track

    visit "/tracks"

    expect(page).to have_content("Tracks")

    expect(page).to have_table_with_exact_data([
      ["Time", "Song", "Artist", "Album", "Year", "Tag", "Video", "Events", "Station", ""],
      [played_at, "Once", "Liam Gallagher", "Once", "2019", "Rock", "youtube", "events", "Marilu", "Show  Edit"]
    ])
  end

  it "edits the track info" do
    played_at = Time.current.strftime("%d.%m.%Y %H:%M")
    track = FactoryBot.create :track, played_at: played_at
    FactoryBot.create :track_info, track: track, year: 2006

    visit "/tracks"

    within "#track_#{track.id}" do
      click_on "Edit"
    end

    fill_in "Name", with: "Twice"
    fill_in "Album", with: "Black"
    fill_in "Artist name", with: "Noel Gallagher"
    fill_in "Year", with: "2020"
    fill_in "Youtube", with: "112"

    click_on "Save"

    expect(page).to have_table_with_exact_data([
      ["Time", "Song", "Artist", "Album", "Year", "Tag", "Video", "Events", "Station", ""],
      [played_at, "Twice", "Noel Gallagher", "Black", "2020", "Rock", "youtube", "events", "Marilu", "Show  Edit"]
    ])

    within "#track_#{track.id}" do
      click_on "Show"
    end

    expect(page).to have_content("Played At: #{played_at}")
    expect(page).to have_content("Title: Twice")
    expect(page).to have_content("Artist: Noel Gallagher")
    expect(page).to have_content("Album: Black")
    expect(page).to have_content("Year: 2020")
    expect(page).to have_content("Main Tag: Rock")
    expect(page).to have_content("Station Name: Marilu")
    expect(page).to have_content("Slug: liamgallagheronce")
  end

  context "events" do
    it "shows the events" do
      played_at = Time.current
      track = FactoryBot.create :track, played_at: played_at
      event = FactoryBot.create :event, track: track
      FactoryBot.create :event
      FactoryBot.create :track_info, track: track
      visit "/tracks"

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
end
