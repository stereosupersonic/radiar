class LastfmJob < ApplicationJob
  queue_as :default

  def perform(track:, track_info:)
    @track = track
    @track_info = track_info
    update_values
  end

  private

  attr_reader :track, :track_info

  def update_values
    return unless api_data

    track_info.album ||= api_data.album.presence
    track_info.tags = api_data.tags if api_data.tags.present?
    track_info.save!
  end

  def api_data
    @api_data ||= LastFmApi.new(
      track: track
    ).call
  end
end
