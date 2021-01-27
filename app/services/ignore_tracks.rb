class IgnoreTracks
  attr_reader :slug
  def initialize(slug:)
    @slug = slug
  end

  def call
    ActiveSupport::Notifications.instrument(:track_event, event_name: :ignore_tracks) do |payload|
    data = { slug: slug }

    ActiveRecord::Base.transaction do
      tracks = Track.where(slug: slug)
      data[:deleted_tracks] = tracks.destroy_all
      track_info = TrackInfo.find_by slug: slug
      if track_info
        data[:track_info] = track_info.id
        track_info.update! ignored: true
      end
    end
    payload[:data] = data
  end
  end
end
