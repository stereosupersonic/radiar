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
FactoryBot.define do
  factory :track_info do
    name { "Once" }
    artist_name { "Liam Gallagher" }
    album { "Once" }
    year { 2019 }
    youtube_id { "MDhiQfekdxo" }
    slug { "liamgallagheronce" }
    tags { %w[rock pop] }
    # wikipedia_summary { "MyText" }
    # wikipedia { "MyText" }
    # mbid { "MyString" }
  end
end
