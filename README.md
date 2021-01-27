
# radiar
next level of the radio radar

[![Ruby Style Guide](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/testdouble/standard)

## development setup

### setup

```
 bin/rails db:setup
```

### start

```
  bin/webpack-dev-server
  bin/server
  bundle exec sidekiq
```

## fetch all stations

```
bundle exec rake radiar:fetch_all
```

## docker

### docker-compose

```
 docker-compose build
```

```
  docker-compose up
  // or with recreare
  docker-compose up --build --force-recreate
```

## production deploy

### checkout source

```
git clone git@github.com:stereosupersonic/radiar.git
```

### setup


create a new file .env
```
cd radiar
cp config/env.sample .env
```

```
PORT=3005 # depend on the other containers
RAILS_MASTER_KEY=XXX # from config config/master.key

DATABASE_HOST="192.168.1.69"
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=postgres_pw
DATABASE_NAME=radiar_production
REDIS_URL_SIDEKIQ=redis://redis:6379/1
```

### build and run image

```
docker-compose -f traefik.yml up -d --build
```


# Data import

```
bin/rails db:schema:load

cat radiar_production_XXX.dump.sql | docker exec -i radiar_database_1 pg_restore -U postgres --exit-on-error --verbose --clean --dbname=radiar_development -Fc
```

cat radiar_production_*.dump.sql | docker exec -i postgresdb12 pg_restore -U postgres --exit-on-error --verbose --clean --dbname=radiar_development -Fc




# data fixes

```
bundle exec rake radiar:fix:missing_track_infos
bundle exec rake radiar:update:unwanted_text
LIMIT=20 bundle exec rake radiar:update:fix_missing_data

```
