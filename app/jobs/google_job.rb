class GoogleJob < ApplicationJob
  queue_as :default

  def perform(track_info_id)
    @track_info = TrackInfo.find track_info_id
    update_values
  end

  private

  attr_reader :track_info

  def update_values
    return unless missing_values?

    data = api_data

    track_info.album ||= data.album.presence
    track_info.tags = data.tags
    track_info.year ||= data.year
    track_info.save!
  end

  def missing_values?
    track_info.album.blank? || track_info.year.blank? || track_info.tags.empty?
  end

  def api_data
    GoogleSearch.new(artist: track_info.track.artist, title: track_info.track.title).call
  end
end