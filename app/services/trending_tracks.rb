class TrendingTracks < BaseService
  LIMIT = 25
  FILTERS = %i[year first_seen_period tag station_id].freeze
  PERIODS = %i[week two_weeks month quater half_year year].freeze
  attr_accessor(*FILTERS)

  def call
    TracksFinder.new(first_seen_on: first_seen_on, year: year, tag: tag, station_id: station_id).call
      .reorder("").group("slug").order(count: :desc).limit(LIMIT).count
      .map { |arr| OpenStruct.new slug: arr.first, count: arr.second }
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
      DateTime.new((year.presence || Time.current.year).to_i, 0o1, 0o1, 0o0, 0o0).beginning_of_year
    end
  end
end
