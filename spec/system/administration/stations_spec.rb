

require "capybara_helper"

describe "Stations", type: :system do
  it "overview page" do
    station = FactoryBot.create :station, name: "Marilu", strategy: :radiobox
    FactoryBot.create :track, station: station, track_info: FactoryBot.create(:track_info)

    visit "/"
    click_on "Stations"
    expect(page).to have_text "Stations Overview"

    expect(page).to have_table_with_exact_data([
      ["Name", "Type", "Active", "Created", "Last update", "tracks last 24h", "all tracks", ""],
      ["Marilu", "radiobox", "true", Time.current.strftime("%d.%m.%Y"), "", "1", "1", "Edit  Show"]
    ])
  end

  it "creates a new station" do
    FactoryBot.create :station, name: "Marilu", strategy: :radiobox
    visit "/"
    click_on "Stations"

    click_on "Edit"

    expect(page).to have_text "Editing Station"

    fill_in "Name", with: "fm42"

    click_on "Save"
    expect(page).to have_content "Station was successfully updated."
    expect(page).to have_table_with_exact_data([
      ["Name", "Type", "Active", "Created", "Last update", "tracks last 24h", "all tracks", ""],
      ["fm42", "radiobox", "true", Time.current.strftime("%d.%m.%Y"), "", "0", "0", "Edit  Show"]
    ])
  end

  it "edits a existin station" do
    visit "/"
    click_on "Stations"

    click_on "Add"

    expect(page).to have_text "New Station"

    fill_in "Name", with: "fm4"
    fill_in "Url", with: "https://planetrock.co.uk"
    fill_in "Playlist url", with: "https://onlineradiobox.com/uk/planetrock/playlist"
    select "radiobox", from: "Strategy"

    click_on "Save"
    expect(page).to have_content "Station was successfully created."
    expect(page).to have_table_with_exact_data([
      ["Name", "Type", "Active", "Created", "Last update", "tracks last 24h", "all tracks", ""],
      ["fm4", "radiobox", "true", Time.current.strftime("%d.%m.%Y"), "", "0", "0", "Edit  Show"]
    ])
  end
end
