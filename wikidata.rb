# https://www.wikidata.org/wiki/Wikidata:Database_reports/List_of_properties/all

search =  Wikidata::Item.search "'Foo Fighters' 'Waiting On A War'"
song =  search.results.first
song.id # => Q104841465
# https://www.wikidata.org/wiki/Q104841465
# https://www.wikidata.org/wiki/Special:EntityData/Q104841465.json


# release date
release = song.property  "P577" # https://www.wikidata.org/wiki/Property:P577
release.value["time"].to_date

# genre
genre = song.property "P136"
genre.title

# album
album =  song.property "P361"
album.title

# youtube
youtube =  song.property "P1651"
youtube.value

# musicbrainz
musicbrainz =  song.property "P436"
musicbrainz.value # https://musicbrainz.org/release-group/4b6fa87b-8a1d-4765-8e5f-a1aaf25853ba

# wikipedia page
## via json
# https://www.wikidata.org/wiki/Special:EntityData/Q104841465.json



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
