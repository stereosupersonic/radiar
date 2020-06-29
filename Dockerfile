FROM ruby:2.6.3
LABEL maintainer="michael@deimel.de"

# Define basic environment variables
ENV NODE_ENV production
ENV RAILS_ENV production
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_SERVE_STATIC_FILES true
ENV SECRET_KEY_BASE=41a33a38a2f752bf9fb53e69fc1e8f91f59bb0099925706cae1312af9e0d074c37690186ee5ef5e83417f39bdeafa386f94d3fab972b63f257c06f73ca8cb686
ENV APP_HOME /app

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  apt-transport-https

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -  
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
  tee /etc/apt/sources.list.d/yarn.list 

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  nodejs \
  cron \
  yarn

RUN gem update --system && \
    gem install bundler

# specify everything will happen within the /app folder inside the container
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

# We copy these files from our current application to the /app container
COPY Gemfile Gemfile.lock ./

# $(nproc) runs bundler in parallel with the amount of CPUs processes 
RUN bundle config set without development test && bundle check || bundle install -j $(nproc)

# caching yarn
COPY package.json yarn.lock ./
RUN yarn install --check-files

COPY . ./
ARG RAILS_MASTER_KEY
RUN RAILS_MASTER_KEY=${RAILS_MASTER_KEY} RAILS_ENV=production bin/rake assets:precompile --trace

EXPOSE 3000

ENTRYPOINT $APP_HOME/entrypoint.sh
