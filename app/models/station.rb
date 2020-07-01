# == Schema Information
#
# Table name: stations
#
#  id             :bigint           not null, primary key
#  enabled        :boolean          default(TRUE)
#  last_logged_at :datetime
#  name           :string           not null
#  playlist_url   :string           not null
#  strategy       :string           not null
#  url            :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_stations_on_last_logged_at  (last_logged_at)
#
class Station < ApplicationRecord
  STRATEGIES = %w[radiobox]
  validates :name, presence: true
  validates :playlist_url, presence: true
  validates :strategy, presence: true, inclusion: {in: STRATEGIES}

  has_many :tracks
end
