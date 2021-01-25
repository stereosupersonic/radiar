# == Schema Information
#
# Table name: track_infos
#
#  id                :bigint           not null, primary key
#  album             :string
#  artist_name       :string           not null
#  ignored           :boolean          default(FALSE), not null
#  mbid              :string
#  name              :string           not null
#  pic_url           :string
#  slug              :string           not null
#  tags              :text             default([]), is an Array
#  wikipedia         :text
#  wikipedia_summary :text
#  year              :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  youtube_id        :string
#
# Indexes
#
#  index_track_infos_on_slug  (slug)
#  index_track_infos_on_year  (year)
#
require "rails_helper"

RSpec.describe TrackInfo, type: :model do
  it "has a valid factory" do
    track_info = FactoryBot.build :track_info

    expect(track_info).to be_valid
    assert track_info.save!
  end
end
