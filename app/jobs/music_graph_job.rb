class MusicGraphJob < ApplicationJob
  queue_as :default

  def perform(track_info_id)
    @track_info = TrackInfo.find track_info_id
    update_values
  end

  private

  attr_reader :track_info

  def update_values
    return unless missing_values?

    response = music_graph_data

    track_info.album ||= response["albumTitle"].presence
    track_info.year ||= response["releaseDate"].to_s[/\d{4}/].presence
    track_info.youtube_id ||= response["ytVideo"].presence
    track_info.pic_url ||= (response["thumbnails"] || {}).values.first
    track_info.save!
  end

  def missing_values?
    track_info.album.blank? || track_info.year.blank? || track_info.youtube_id.blank? || track_info.pic_url.blank?
  end

  def music_graph_data
    MusicGraphApi.new(artist: track_info.track.artist, title: track_info.track.title).call
  end
end
