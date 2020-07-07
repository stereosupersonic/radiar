class LastfmJob < ApplicationJob
  queue_as :default

  def perform(track_info_id)
    @track_info = TrackInfo.find track_info_id

    update_values
  end

  private

  attr_reader :track_info

  def update_values
    return unless api_data

    track_info.reload
    track_info.album ||= api_data.album.presence
    track_info.tags = api_data.tags if api_data.tags.present?
    track_info.save!
  end

  def api_data
    @api_data ||= LastFmApi.new(
      artist: track_info.track.artist,
      title: track_info.track.title,
      track: track_info.track
    ).call
  end
end
