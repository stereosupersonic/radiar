class GoogleJob < ApplicationJob
  queue_as :default

  def perform(track_info:, track: nil)
    @track = track
    @track_info = track_info
    update_values
  end

  private
    attr_reader :track, :track_info

    def update_values
      return unless missing_values?
      data = { query: google_search.url }

      ActiveSupport::Notifications.instrument(:log_api_request, event_name: :google_search) do |payload|
        payload[:status] = :ok
        payload[:track] = track
        payload[:track_info] = track_info

        if api_data
          data[:google_data] = api_data.to_h
          track_info.album = api_data.album if  track_info.album.blank? && api_data.album.present?
          track_info.tags = api_data.tags if track_info.tags.empty? && api_data.tags.present?
          track_info.year = api_data.year if track_info.year.blank? && api_data.year.present?
          track_info.youtube_id = api_data.youtube_id if track_info.youtube_id.blank? && api_data.youtube_id.present?
          data[:changes] = track_info.changes
          track_info.save!
        else
          payload[:status] = :no_data
        end
        payload[:data] = data
      end
    end

    def missing_values?
      track_info.album.blank? || track_info.year.blank? || track_info.tags.empty? || track_info.youtube_id.blank?
    end

    def google_search
      @google_search ||= GoogleSearch.new artist: track_info.artist_name, title: track_info.name
    end

    def api_data
      @api_data ||= google_search.call
    end
end
