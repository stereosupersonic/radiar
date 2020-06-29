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
class Station < ApplicationRecord
  validates :name, presence: true
  validates :playlist_url, presence: true
  validates :strategy, presence: true
end
