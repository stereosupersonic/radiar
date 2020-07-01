# == Schema Information
#
# Table name: track_infos
#
#  id                :bigint           not null, primary key
#  album             :string
#  artist_name       :string           not null
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
  pending "add some examples to (or delete) #{__FILE__}"
end
