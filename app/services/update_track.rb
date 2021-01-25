class UpdateTrack
  def initialize(track)
    @track = track
  end

  def call
    return unless @track

    ActiveRecord::Base.transaction do
      @track.title = TrackSanitizer.new(text: @track.title).call
      @track.artist = TrackSanitizer.new(text:@track.artist).call
      @track.slug = SlugBuilder.new(artist: @track.artist, title: @track.title).call
      @track.save!
      CreateTrackInfo.new(@track).call
    end

    clean_empty_track_infos
  end

  private

    def clean_empty_track_infos
      # TODO

     #
    end

end
