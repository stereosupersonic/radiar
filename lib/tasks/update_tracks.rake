require "ruby-progressbar"

namespace :radiar do
  namespace :fix do
    desc "track infos"
    task missing_track_infos: [:environment] do
      tracks = Track.where(track_info_id: nil).where.not(slug: nil)
      progress_bar = ProgressBar.create(title: "update tracks", total: tracks.count, format:  "%t %c/%C: |%B| %E")
      tracks.find_each do | track |
        track_info = TrackInfo.find_by(slug: track.slug)
        track.track_info = track_info
        track.save!

        progress_bar.increment
      end
    end
  end

  namespace :update do
    desc "add metadata"
    task fix_missing_data: [:environment] do
      limit = ENV["LIMIT"] || 100
      track_infos = TrackInfo.where("year is null or album is null").order("id desc").limit(limit.to_i)
      progress_bar = ProgressBar.create(title: "updated trackinfo", total: track_infos.count,
        format:  "%t %c/%C: |%B| %E")
      track_infos.find_each do |track_info|
       WikiDataJob.perform_later(track_info: track_info)
       GoogleJob.perform_later(track_info: track_info)
       LastfmJob.perform_later(track_info: track_info)

       progress_bar.increment
     end
    end

    desc "remove unwanted"
    task unwanted_text: [:environment] do
      TrackSanitizer::UNWANTED_TEXT.each do |unwanted|
        tracks = Track.where("title like '%#{unwanted}%' or artist like '%#{unwanted}%'")
        progress_bar = ProgressBar.create(title: "clean tracks from '#{unwanted}'", total: tracks.count,
format:  "%t %c/%C: |%B| %E")
        tracks.find_each do |track|
          UpdateTrack.new(track).call

          progress_bar.increment
        end
      end
    end
  end
end
