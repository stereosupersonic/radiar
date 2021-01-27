# https://www.wikidata.org/wiki/Wikidata:Database_reports/List_of_properties/all

# music properties https://www.wikidata.org/wiki/Wikidata:WikiProject_Music

# EXamples


# Master of Pupperts
# https://www.wikidata.org/wiki/Q383630
song = Wikidata::Item.find "Q383630"
song = Wikidata::Item.find "Q328482"


search =  Wikidata::Item.search "Pale Waves easy"
search =  Wikidata::Item.search "'Foo Fighters' 'Waiting On A War'"
search =  Wikidata::Item.search "'Ataris' 'The Boys Of Summer'"
song =  search.results.first
song.id # => Q104841465
song.title
# https://www.wikidata.org/wiki/Q104841465
# https://www.wikidata.org/wiki/Special:EntityData/Q104841465.json


# artist
artist = song.property("P175")
artist&.title

artist = Wikidata::Item.find song.property("P175").id
artist.image.url
spotify_id = artist.property("P1902").value

# release date
release = song.property  "P577" # https://www.wikidata.org/wiki/Property:P577
release.value["time"].to_date

# genre
genre = song.property "P136"
genre.title

# album
song.property("P361")&.title
album = Wikidata::Item.find song.property("P361")&.id
album.property("P136").title # genre
album.property("P577").value.time # publication date
album.property("P436").value  # musicbrainz id
album.property("P2205").value  # spotify

# youtube
youtube =  song.property("P1651")&.value


# musicbrainz
musicbrainz =  song.property("P436")&.id
musicbrainz.value # https://musicbrainz.org/release-group/4b6fa87b-8a1d-4765-8e5f-a1aaf25853ba

# wikipedia page
## via json
# https://www.wikidata.org/wiki/Special:EntityData/Q104841465.json
require 'net/http'
require 'json'

id = "Q104841465"
id = "Q383630"

url = "https://www.wikidata.org/wiki/Special:EntityData/#{id}.json"
response = Net::HTTP.get(URI(url))
data = JSON.parse(response)
data["entities"][id]["sitelinks"]["enwiki"]["url"] # en
data["entities"][id]["sitelinks"]["dewiki"]["url"] # de
##################################################################################
## musicbrainz
##################################################################################
### api search https://musicbrainz.org/doc/MusicBrainz_API/Search

# find via recording https://wiki.musicbrainz.org/Recording

http://musicbrainz.org/ws/2/recording/?query=artist:foo+fighters%AND%20recording:waiting+for+the+war&fmt=json


# find first release => first release group

# this includes
# "url": {
# "id": "6d5a11ff-f897-4d1a-b8be-2bed9d9abc8a",
# "resource": "https://www.wikidata.org/wiki/Q104841465"

http://musicbrainz.org/ws/2/release-group/4b6fa87b-8a1d-4765-8e5f-a1aaf25853ba?inc=url-rels&fmt=json


# release
# https://musicbrainz.org/ws/2/release/5ec0eac2-396f-46a8-8b59-e1858a0c0867?inc=url-rels&fmt=json

### artist with wikidata id
# https://musicbrainz.org/ws/2/artist/67f66c07-6e61-4026-ade5-7e782fad3a5d?inc=url-rels&fmt=json



# example 2 search releases by
http://musicbrainz.org/ws/2/recording/?query=artist:moby%20AND%20recording:into+the+blue&fmt=json

http://musicbrainz.org/ws/2/release-group/7f6a4e72-9fee-39db-8817-63425f97a0f5?inc=url-rels&fmt=json



#example 3
http://musicbrainz.org/ws/2/recording/?query=artist:Chevelle%20AND%20Self+Destructor&fmt=json
http://musicbrainz.org/ws/2/release-group/99ac2205-efd7-4e00-9717-b17672142d1a?inc=url-rels&fmt=json

#example 4 #NOT WORKING
http://musicbrainz.org/ws/2/recording/?query=artist:METALLICA%AND%20recording:ONE&fmt=json
