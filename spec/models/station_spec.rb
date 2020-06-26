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
require 'rails_helper'

RSpec.describe Station, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
