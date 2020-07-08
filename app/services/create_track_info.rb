class CreateTrackInfo
  def initialize(track)
    @track = track
  end

  def call
    return track.track_info if track.track_info

    track_info = TrackInfo.find_by(slug: track.slug)
    if track_info
      ActiveSupport::Notifications.instrument(:track_info_creation, event_name: :track_info_exits) do |payload|
        payload[:data] = {track_info: track_info.id, artist: track.artist, title: track.title}
        payload[:track] = track
        track.update! track_info: track_info
      end
      track_info
    else
      ActiveSupport::Notifications.instrument(:track_info_creation, event_name: :track_info_created) do |payload|
        payload[:track] = track
        track_info = create_new
        payload[:data] = {track_info: track_info.id, artist: track.artist, title: track.title}
        track_info
      end
    end
  end

  private

  attr_reader :track

  def create_new
    track_info = track.build_track_info

    track_info.slug = track.slug
    track_info.artist_name = track.artist
    track_info.name = track.title
    track_info.save!
    track_info
  end
end
