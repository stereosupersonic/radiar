class GoogleJob < ApplicationJob
  queue_as :default

  def perform(track:, track_info:)
    @track = track
    @track_info = track_info
    update_values
  end

  private
    attr_reader :track, :track_info

    def update_values
      return unless missing_values?

      return unless api_data

      track_info.album = api_data.album if api_data.album.present?
      track_info.tags = api_data.tags if track_info.tags.empty? && api_data.tags.present?
      track_info.year = api_data.year if api_data.year.present?
      track_info.save!
    end

    def missing_values?
      track_info.album.blank? || track_info.year.blank? || track_info.tags.empty?
    end

    def api_data
      @api_data ||= GoogleSearch.new(
        track: track
      ).call
    end
end
