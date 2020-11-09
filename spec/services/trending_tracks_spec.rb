require "rails_helper"

RSpec.describe TrendingTracks do
  it "first_seen_on" do
    TrendingTracks::PERIODS.each do |period|
      expect(TrendingTracks.new(first_seen_period: period).call).to be_empty
    end
  end
end
