class MusicGraphJob < ApplicationJob
  queue_as :default

  def perform(track_id)
    @track = Track.find track_id
    return if track.track_info
    track_info = TrackInfo.find_by(slug: track.slug)

    if track_info
      track.update track_info: track_info
    else
      create_new
    end
  end

  private

  attr_reader :track

  def create_new
    track_info = track.build_track_info

    response = MusicGraphApi.new(artist: track.artist, title: track.title).call
    track_info.slug = track.slug
    track_info.album = response["albumTitle"].presence
    track_info.artist_name = response["artist"]
    track_info.name = response["songName"]
    track_info.year = response["releaseDate"].to_s[/\d{4}/].presence
    track_info.youtube_id = response["ytVideo"].presence
    track_info.pic_url = (response["thumbnails"] || {}).values.first
    track_info.save!
  end

  def find_or_create_info(track)
    track.build_track_info
  end
end
