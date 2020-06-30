#!/bin/bash

# Start the run once job.
echo "Docker container has been started"

if [ "$SIDEKIQ" == 1 ]; then
  echo "start sidekiq"
  bundle exec sidekiq -p critical -q default -q low
else
  echo "start rails server"
  # Setup a cron test schedule
  mkdir -p /var/log/
  touch /var/log/cron.log

  echo "write whenever cront entries"
  bundle exec whenever --update-crontab

  echo "start cron service"
  service cron start
  echo "run migrations"
  bundle exec rails db:migrate
  mkdir -p /app/tmp/pids
  rm -f /app/tmp/pids/server.pid
  bundle exec rails server -b 0.0.0.0 -p 3000
fi
