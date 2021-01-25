require "rails_helper"

RSpec.describe IgnoreTracks do
  it "should remov all tracks and set Track info to ignored" do
    track_info = create(:track_info, slug: "queenradiogaga")
    create(:track, track_info: track_info, slug: "queenradiogaga")
    create(:track, track_info: track_info, slug: "queenradiogaga")
    create(:track, track_info: track_info, slug: "queenradiogaga")

    expect {
      IgnoreTracks.new(slug: "queenradiogaga").call
    }.to  change(Track, :count).by(-3)

    expect(track_info.reload.ignored).to eq true
  end
end
