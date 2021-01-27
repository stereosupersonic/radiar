class TrackInfoPresenter < ApplicationPresenter
  SHOW_ATTRIBUTES = %w[
    title
    artist
    album
    year
    main_tag
    tags
    slug
    youtube_link
    wikidata_link
    wiki_page_url
    spotify_link
    mbid_link
    artist_wikidata_link
    wiki_artist_page_url
    artist_spotify_link
    artist_mbid_link
    album_wikidata_link
    wiki_album_page_url
    album_spotify_link
    album_mbid_link]

  def title
    h.truncate o&.name
  end

  def info
    "#{artist} - #{title}" if o
  end

  def artist
    h.truncate o&.artist_name
  end

  def album
    h.truncate o&.album
  end

  def year
    o&.year
  end

  def tags
    o&.tags
  end

  def youtube_id
    o&.youtube_id
  end

  def main_tag
    h.truncate Array(tags).first&.titleize
  end

  def stations
    @stations ||= o.tracks.pluck(:station_id).uniq.map { |station_id| Admin::StationPresenter.new(Station.find(station_id)) }
  end

  def stations_count(station)
    o.tracks.where(station_id: station.id).count
  end

  def youtube_url
    "https://www.youtube.com/watch?v=#{youtube_id}" if youtube_id.present?
  end

  def youtube_link
    build_link youtube_url
  end

  def wikidata_link
    build_link build_wikidata_url(o.wikidata_id)
  end

  def  wiki_page_url
    wiki_page wikidata_id if o.wikidata_id.present?
  end

  def album_wikidata_link
    build_link  build_wikidata_url(o.album_wikidata_id)
  end

  def artist_wikidata_link
    build_link  build_wikidata_url(o.artist_wikidata_id)
  end

  def  wiki_artist_page_url
    wiki_page o.artist_wikidata_id if o.artist_wikidata_id.present?
  end

  def  wiki_album_page_url
    wiki_page o.album_wikidata_id if o.album_wikidata_id.present?
  end

  def spotify_link
    build_link "https://open.spotify.com/track/#{o.spotify_id}" if o.spotify_id.present?
  end

  def mbid_link
    build_link  "https://musicbrainz.org/recording/#{o.mbid}"  if o.mbid.present?
  end

  def album_spotify_link
    build_link  "https://open.spotify.com/album/#{o.album_spotify_id}" if o.album_spotify_id.present?
  end

  def album_mbid_link
    build_link  "https://musicbrainz.org/release-group/#{o.album_mbid}" if o.album_mbid.present?
  end

  def artist_spotify_link
    build_link  "https://open.spotify.com/artist/#{o.artist_spotify_id}" if o.artist_spotify_id.present?
  end

  def artist_mbid_link
    build_link  "https://musicbrainz.org/artist/#{o.artist_mbid}" if o.artist_mbid.present?
  end

  def build_wikidata_url(wiki_id)
    "https://www.wikidata.org/wiki/#{wiki_id}" if wiki_id.present?
  end

  def build_link(url)
    url.present? ? h.link_to(url, url) : ""
  end

  def wiki_page(wiki_id)
    url = wikipage_url(wiki_id)
    h.link_to url, url if url
  end

  def wikipage_url(wiki_id)
    url = "https://www.wikidata.org/wiki/Special:EntityData/#{wiki_id}.json"
    response = Net::HTTP.get(URI(url))
    data = JSON.parse(response)
    site_links = data.dig("entities", wiki_id, "sitelinks") || {}

    site_links.dig("enwiki", "url") || site_links.dig("dewiki", "url")
  end
end
