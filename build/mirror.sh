#!/usr/bin/env bash
#
# Connects to our podman host, using the setup we describe in the
# "podman-rsync-proxy" project, to run mysqldump commands
set -eu

mkdir -p ./exports/db
source ./build/mirror-vars.sh

echo "Mirroring database structure..."
ssh $dev@$pod_host sudo -u $podman_user /usr/local/bin/podman-mysqldump.sh $pod_subdir $service \
    -d spotlight \
    > ./exports/db/001-struct.sql
echo "Done (structure)."

echo "Mirroring non-guest users..."
ssh $dev@$pod_host sudo -u $podman_user /usr/local/bin/podman-mysqldump.sh $pod_subdir $service \
    -t spotlight users '--where="guest = 0"' \
    > ./exports/db/002-users.sql
echo "Done (users)."

echo "Mirroring core tables..."
ssh $dev@$pod_host sudo -u $podman_user /usr/local/bin/podman-mysqldump.sh $pod_subdir $service \
    -t --ignore-table=spotlight.searches --ignore-table=spotlight.users spotlight \
    | sed 's|https://expo.uoregon.edu/|http://localhost:3000/|g' \
    > ./exports/db/003-core.sql
echo "Done (core)."

echo "Done."
