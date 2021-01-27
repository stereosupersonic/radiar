class WikiDataJob < ApplicationJob
  queue_as :default

  def perform(track_info:, track: nil)
    @track_info = track_info
    @track = track
    update_values
  end

  private
    attr_reader :track_info, :track

    def update_values
      ActiveSupport::Notifications.instrument(:log_api_request, event_name: :wikidata_search) do |payload|
        data = { query: query }
        payload[:status] = :no_data
        if song && artist
          data[:song] = JSON.parse song.to_json

          # PROBLEM
          # Ataris The Boys Of Summer => don henley  The Boys Of Summer

          wiki_slug =  SlugBuilder.new(artist: artist&.title, title: song.title).call if artist

          if wiki_slug == track_info.slug
            payload[:status] = :ok
            # TODO fix
            # 'Slug: wiki_slug:''thecranberrieszombie'' <> ''cranberrieszombie'' '

            # track_info.artist_name = artist&.title if artist&.title
            # track_info.name = song.title
            track_info.wikidata_id = song.id
            track_info.album = album_name if album_name.present?
            track_info.tags = Array(genre) if track_info.tags.empty? && genre.present?
            track_info.year = year if year.present?
            track_info.youtube_id = youtube_id if youtube_id.present?
            track_info.spotify_id = spotify_id if spotify_id.present?

            track_info.album_wikidata_id = album_wikidata_id if album_wikidata_id.present?
            track_info.album_spotify_id = album_spotify_id if album_spotify_id.present?
            track_info.album_mbid = album_mbid if album_mbid.present?

            track_info.artist_wikidata_id = artist_wikidata_id if artist_wikidata_id.present?
            track_info.artist_spotify_id = artist_spotify_id if artist_spotify_id.present?
            track_info.artist_mbid = artist_mbid if artist_mbid.present?

            data[:changes] = track_info.changes

            track_info.save!
          else
            data[:error] = "Slug: wiki_slug:'#{wiki_slug}' <> '#{track_info.slug}' "
            payload[:status] = :failed
          end
        else
          payload[:status] = :no_data
        end

        payload[:track_info] = track_info
        payload[:track] = track
        payload[:data] = data
      end
    end

    def missing_values?
      track_info.album.blank? || track_info.year.blank? || track_info.tags.empty? || track_info.youtube_id.blank?
    end

    def  query
      "'#{track_info.artist_name}' song:'#{track_info.name}'"
    end

    def song
      return @song if defined?(@song)

      @song = Wikidata::Item.search(query).results&.first

      @song
    end

    def genre
      song.property("P136")&.title
    end

    def year
      release = song.property("P577")
      time = release.value["time"] if release
      time.to_date&.year if time.present?
    rescue ArgumentError
      time[/.?(\d{4})-/, 1]
    end

    def youtube_id
      song.property("P1651")&.value
    end

    # https://www.wikidata.org/wiki/Property:P2207
    def spotify_id
      song.property("P2207")&.value
    end

    def album
      return @album if defined?(@album)

      @album = song.property("P361")
    end

    def album_name
      album&.title
    end

    def album_wikidata_id
      album&.id
    end

    # https://www.wikidata.org/wiki/Property:P2205
    # spotify album id
    def album_spotify_id
      album.property("P2205")&.value if album
    end

    # https://www.wikidata.org/wiki/Property:P436
    # MusicBrainz release group ID
    def album_mbid
      album.property("P436")&.value if album
    end

    def artist
      return @artist if defined?(@artist)

      @artist = song.property("P175")
    end

    def artist_wikidata_id
      artist&.id
    end

    # https://www.wikidata.org/wiki/Property:P1902
    # Spotify artist ID
    def artist_spotify_id
      artist.property("P1902")&.value if artist
    end

    # https://www.wikidata.org/wiki/Property:P434
    # MusicBrainz artist ID
    def artist_mbid
      artist.property("P434")&.value if artist
    end
end
