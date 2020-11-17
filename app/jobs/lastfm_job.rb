class LastfmJob < ApplicationJob
  delegate :track_info, to: :track

  queue_as :default

  def perform(track:)
    @track = track
    update_values
  end

  private

  attr_reader :track

  def update_values
    return unless api_data
    return unless track_info

    track_info.reload
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
