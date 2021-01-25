require "rails_helper"

RSpec.describe UpdateTrackInfo do
  it "should remov all tracks when slug changed" do
    track_info_old = create(:track_info, artist_name: "Queen", name: "radio gaga", slug: "queenradiogaga")
    track_info = create(:track_info, artist_name: "Queen1", name: "radio gaga", slug: "queen1radiogaga")
    changed_1 = create(:track, track_info: track_info, slug: "queen1radiogaga")
    create(:track, track_info: track_info_old, slug: "queenradiogaga")
    create(:track, track_info: track_info_old, slug: "queenradiogaga")

    expect {
      UpdateTrackInfo.new(track_info, { artist_name: "Queen" }).call
    }.to change(TrackInfo, :count).by(-1)

    expect(track_info_old.reload.tracks.count).to eq 3
    expect(changed_1.reload.slug).to eq "queenradiogaga"
    expect(Track.where(slug: "queen1radiogaga").count).to eq 0
  end
end
