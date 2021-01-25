class UpdateTrackInfo
  def initialize(track_info, params)
    @track_info = track_info
    @params = params
  end

  def call
    return unless @track_info
    return if @params.blank?
    ActiveRecord::Base.transaction do
      @track_info.update! @params

      if @track_info.name_previously_changed? || @track_info.artist_name_previously_changed?
        old_slug = @track_info.slug
        new_slug = SlugBuilder.new(artist: @track_info.artist_name, title: @track_info.name).call
        if old_slug != new_slug
          Track.where(slug: old_slug).update_all(slug: new_slug)
          existing_track_info = TrackInfo.find_by slug: new_slug
          if existing_track_info
            @track_info.delete
            Track.where(slug: new_slug).update_all(track_info_id: existing_track_info.id)
          else
            @track_info.update slug: new_slug
            Track.where(slug: new_slug).update_all(track_info_id: @track_info.id)
          end
        end
      end
    end
  end
end
