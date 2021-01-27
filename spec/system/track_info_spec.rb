

require "capybara_helper"

describe "show TrackInfo", type: :system do
  it "show the track info" do
    track_info = FactoryBot.create :track_info, album: "big"
    visit "/track_infos/#{track_info.id}"

    expect(page).to have_content("Title: Once")
    expect(page).to have_content("Artist: Liam Gallagher")
    expect(page).to have_content("Album: big")
    expect(page).to have_content("Year: 2019")
    expect(page).to have_content("Main Tag: Rock")
    expect(page).to have_content("Slug: liamgallagheronce")
  end
end
