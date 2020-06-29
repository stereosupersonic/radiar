# == Schema Information
#
# Table name: stations
#
#  id           :bigint           not null, primary key
#  enabled      :boolean          default(TRUE)
#  name         :string
#  playlist_url :string
#  strategy     :string
#  url          :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :station do
    name { "Marilu" }
    url { "https://www.marilu.it/" }
    playlist_url { "https://onlineradiobox.com/it/marilu/playlist/" }
    strategy { "radiobox" }
  end
end
