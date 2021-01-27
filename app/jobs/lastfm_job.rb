class LastfmJob < ApplicationJob
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
      return if ENV["LASTFM_API_KEY"].blank?
      data = { query: last_fm_client.url }

      ActiveSupport::Notifications.instrument(:log_api_request, event_name: :lastfm_search) do |payload|
        payload[:status] = :ok
        payload[:track] = track
        payload[:track_info] = track_info

        if api_data
          data[:last_fm_data] = api_data.to_h
          track_info.album = api_data.album if  api_data.album.present? && track_info.album.blank?
          # always trust the lastfm tags
          track_info.tags = api_data.tags if api_data.tags.present?

          data[:changes] = track_info.changes

          track_info.save!
        else
          payload[:status] = :no_data
        end
        payload[:data] = data
      end
    end

    def missing_values?
      track_info.album.blank? || track_info.tags.empty?
    end

    def last_fm_client
      @last_fm_client ||= LastFmApi.new(artist: track_info.artist_name, title: track_info.name)
    end

    def api_data
      @api_data ||= last_fm_client.call
    end
end
