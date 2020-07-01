# frozen_string_literal: true

require "capybara_helper"

describe "Stations", type: :system do
  it "overview page" do
    FactoryBot.create :station, name: "Marilu", strategy: :radiobox
    visit "/"
    click_on "Stations"
    expect(page).to have_text "Stations Overview"

    expect(page).to have_table_with_exact_data([
      ["Name", "Type", "Active", "Last update", ""],
      ["Marilu", "radiobox", "true", "", "edit"]
    ])
  end

  it "creates a new station" do
    FactoryBot.create :station, name: "Marilu", strategy: :radiobox
    visit "/"
    click_on "Stations"

    click_on "edit"

    expect(page).to have_text "Editing Station"

    fill_in "Name", with: "fm42"

    click_on "Save"
    expect(page).to have_content "Station was successfully updated."
    expect(page).to have_table_with_exact_data([
      ["Name", "Type", "Active", "Last update", ""],
      ["fm42", "radiobox", "true", "", "edit"]
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
      ["Name", "Type", "Active", "Last update", ""],
      ["fm4", "radiobox", "true", "", "edit"]
    ])
  end
end
