module Admin
  class StationPresenter < ApplicationPresenter
    def last_logged_track
      return unless last_logged_at
      "#{h.time_ago_in_words(last_logged_at)} (#{h.format_datetime last_logged_at})"
    end

    def created
      h.format_date o.created_at
    end

    def problematic?
      return unless last_logged_at

      last_logged_at < 1.day.ago
    end

    def tracks_count(period = nil)
      if period
        tracks.where(played_at: (period...Time.current)).count
      else
        tracks.count
      end
    end
  end
end
