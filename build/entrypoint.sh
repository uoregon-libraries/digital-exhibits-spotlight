#!/bin/bash

# wait_for_database actually waits for migrations to succeed, since that's
# something we always want. The migration command will always succeed if there
# are no migrations to run.
wait_for_database() {
  echo "Running Rails database migrations"
  i=0
  while [ "$i" -lt 10 ]; do
    i=$((i + 1))
    bundle exec rails db:migrate &>/dev/null && return
    echo "migrations failed, waiting 5 seconds to try again"
    sleep 5
  done

  bundle exec rails db:migrate || exit 1
}

bundle_install() {
  echo "Verifying bundled gems are installed"
  rm -f tmp/pids/server.pid
  bundle install
}

compile_assets() {
  # We don't want to recompile assets more than once a week, at least not on
  # container startup - it's just incredibly slow even when there are *no
  # changes*. Devs can manually recompile more often if needed.
  dtfile="public/assets/precompiled.$(date +'%Y-%W')"
  if [[ ! -f $dtfile ]]; then
    echo "Precompiling assets"
    rails assets:precompile
    touch $dtfile
  fi
}

# When user requests bash or sh, don't run the init function
case "$@" in
  bash | sh )
    exec "$@"
  ;;

  *)
  bundle_install
  wait_for_database
  compile_assets
  echo "Running bundle exec $@..."
  exec bundle exec "$@"
esac
