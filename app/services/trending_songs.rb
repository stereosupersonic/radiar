class TrendingSongs < BaseService
  LIMIT = 50
  attr_accessor :year
  def call
    Track.find_by_sql("SELECT t.slug, count(t.slug) as count FROM public.tracks t, track_infos i " \
       "where i.id = t.track_info_id and i.year = #{year} group by t.slug order by count desc LIMIT #{LIMIT}")
      .map { |t| OpenStruct.new slug: t.slug, count: t.count }
  end
end
