class SlugBuilder
  def initialize(title:, artist:)
    @title = title
    @artist = artist
  end

  def call
    raise "artist could not be nil" if @artist.blank?
    raise "title could not be nil" if @title.blank?

    "#{@artist}#{@title}".gsub(/[^\w|:]/, "").gsub(/(\+|-|_|\.)/, "").to_s.downcase
  end
end
