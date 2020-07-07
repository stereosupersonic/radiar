# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Station.create(
  name: "Marilu",
  url: "https://www.marilu.it/",
  playlist_url: "https://onlineradiobox.com/it/marilu/playlist/",
  strategy: "radiobox"
)

Station.create(
  name: "Absolute Radio",
  url: "https://planetradio.co.uk/absolute-radio/",
  playlist_url: "https://onlineradiobox.com/uk/absolute1058/playlist/",
  strategy: "radiobox"
)

Station.create(
  name: "Planet Rock",
  url: "https://planetradio.co.uk/planet-rock",
  playlist_url: "https://onlineradiobox.com/uk/planetrock/playlist",
  strategy: "radiobox"
)

Station.create(
  name: "fm4",
  url: "https://fm4.orf.at",
  playlist_url: "https://onlineradiobox.com/uk/fm4/playlist",
  strategy: "radiobox",
  enabled: false
)

Station.create(
  name: "fluxfm",
  playlist_url: "https://onlineradiobox.com/de/fluxfm1006/playlist",
  strategy: "radiobox"
)

Station.create(
  name: "xs manchester",
  playlist_url: "https://onlineradiobox.com/uk/xsmanchester/playlist",
  strategy: "radiobox"
)

Station.create(
  name: "Q106",
  playlist_url: "https://onlineradiobox.com/us/wjxq/playlist",
  strategy: "radiobox"
)

Station.create(
  name: "The Zone",
  playlist_url: "https://onlineradiobox.com/ca/cjzn/playlist",
  strategy: "radiobox"
)
