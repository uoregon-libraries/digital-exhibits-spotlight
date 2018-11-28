#!/bin/sh

rm -f tmp/pids/server.pid

if bundle exec rails db:migrate:status &> /dev/null; then
  bundle exec rails db:migrate
fi

bundle exec rails s
