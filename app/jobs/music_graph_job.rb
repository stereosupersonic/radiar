class MusicGraphJob < ApplicationJob
  queue_as :default

  sidekiq_options retry: 2

  def perform(track_info_id)
    @track_info = TrackInfo.find track_info_id

    update_values
  end

  private

  attr_reader :track_info

  def update_values
    return unless missing_values?
    return unless api_data

    track_info.album ||= api_data.album.presence
    track_info.year ||= api_data.year.presence
    track_info.youtube_id ||= api_data.youtube_id.presence
    track_info.pic_url ||= api_data.pic_url.presence

    track_info.save!
  end

  def missing_values?
    track_info.album.blank? || track_info.year.blank? || track_info.youtube_id.blank? || track_info.pic_url.blank?
  end

  def api_data
    @api_data ||= MusicGraphApi.new(artist: track_info.track.artist, title: track_info.track.title).call
  end
end
