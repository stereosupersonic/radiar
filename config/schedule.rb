# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
#
# https://github.com/javan/whenever
#
set :output, "/var/log/cron.log"

ENV.each { |k, v| env(k, v) } # bug fix for https://stackoverflow.com/questions/31118033/could-not-find-rake-using-whenever-rails

every 3.minutes do
  rake "radiar:fetch_all"
end
