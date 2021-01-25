class TrendingTracks < BaseService
  include ActiveModel::Attributes
  LIMIT = 25
  FILTERS = %i[year first_seen_period tag station_id artist more_stations].freeze
  PERIODS = %i[week two_weeks month quater half_year year].freeze
  attr_accessor(*(FILTERS - [:more_stations, :first_seen_period]))

  attribute :more_stations, :boolean, default: true
  attribute :first_seen_period, :string, default: :week

  def call
    TracksFinder.new(first_seen_on: first_seen_on, year: year, tag: tag, station_id: station_id, artist: artist,
more_stations: more_stations).call
      .reorder("").group("slug").order(count: :desc).limit(LIMIT).count
      .map { |arr|
 OpenStruct.new slug: arr.first, count: arr.second }
  end

  def first_seen_on
    case first_seen_period.to_s.to_sym
    when :week
      1.week.ago
    when :two_weeks
      2.weeks.ago
    when :month
      1.month.ago
    when :quater
      3.months.ago
    when :half_year
      6.months.ago
    when :year
      1.year.ago
    else
      nil
    end
  end
end
