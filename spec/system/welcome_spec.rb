# frozen_string_literal: true

require "capybara_helper"

describe "welcome", type: :system do
  it "shows the tranding tracks of this year" do
    travel_to DateTime.new(2020, 12, 14, 13, 30) do
      track_info = FactoryBot.create :track_info, artist_name: "Metallica", slug: :blah1, name: "one", year: 2020
      FactoryBot.create :track, slug: :blah1, played_at: 1.week.ago, track_info: track_info

      track_info2 = FactoryBot.create :track_info, artist_name: "Abba", slug: :blah2, year: 2019
      FactoryBot.create :track, slug: :blah2, played_at: 2.months.ago, track_info: track_info2
      visit "/"

      expect(page).to have_content("Trending Songs")
      expect(page).to have_content("Metallica")

      expect(page).to_not have_content("Abba")
    end
  end
end
