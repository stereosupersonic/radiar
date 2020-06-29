# == Schema Information
#
# Table name: stations
#
#  id             :bigint           not null, primary key
#  enabled        :boolean          default(TRUE)
#  last_logged_at :datetime
#  name           :string
#  playlist_url   :string
#  strategy       :string
#  url            :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_stations_on_last_logged_at  (last_logged_at)
#
FactoryBot.define do
  factory :station do
    name { "Marilu" }
    url { "https://www.marilu.it/" }
    playlist_url { "https://onlineradiobox.com/it/marilu/playlist/" }
    strategy { "radiobox" }
  end
end
