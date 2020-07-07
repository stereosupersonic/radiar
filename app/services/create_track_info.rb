class CreateTrackInfo
  def initialize(track)
    @track = track
  end

  def call
    return track.track_info if track.track_info

    track_info = TrackInfo.find_by(slug: track.slug)
    if track_info
      track.update! track_info: track_info
    else
      create_new
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
