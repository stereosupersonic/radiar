# == Schema Information
#
# Table name: track_infos
#
#  id                :bigint           not null, primary key
#  album             :string
#  artist_name       :string           not null
#  mbid              :string
#  name              :string           not null
#  slug              :string
#  tags              :text             default([]), is an Array
#  wikipedia         :text
#  wikipedia_summary :text
#  year              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  youtube_id        :string
#
# Indexes
#
#  index_track_infos_on_slug  (slug)
#
FactoryBot.define do
  factory :track_info do
    name { "MyString" }
    artist_name { "MyString" }
    album { "MyString" }
    year { "MyString" }
    youtube_id { "MyString" }
    tags { "MyText" }
    wikipedia_summary { "MyText" }
    wikipedia { "MyText" }
    mbid { "MyString" }
  end
end
