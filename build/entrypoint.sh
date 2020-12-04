#!/bin/sh

rm -f tmp/pids/server.pid

if bundle exec rails db:migrate:status &> /dev/null; then
  bundle exec rails db:migrate
fi
bundle install
bundle exec sidekiq -C ./config/sidekiq.yml &
bundle exec rails s -b 0.0.0.0
