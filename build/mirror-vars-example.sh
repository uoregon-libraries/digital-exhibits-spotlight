# Copy this file to `build/mirror-vars.sh` and adjust as needed to mirror your
# production data

# What's the hostname for your podman host?
export pod_host=my-first-podman.uoregon.edu

# Who do you log into $pod_host as?
export dev=jechols

# What's the subdirectory for the project you're mirroring (relative to the
# podman host's configured $PODMAN_PROJECT_ROOT)
export pod_subdir=spotlight

# What is the service name for your database container?
export service=db

# Who do you need to switch to? (per our podman proxy project, the mirror /
# sync scripts require specific users to run commands)
export podman_user=sir_podman

# What's the base URL of the production site? The spotlight setup has
# hard-coded URLs, so we need to rewrite the URLs found in the DB. Note that
# this is a very basic search-and-replace. If this value is *anywhere* in your
# database, it is going to be changed.
export base_url_remote=https://my-first-spotlight.uoregon.edu/

# What's the base URL of *this* project? In dev, it's probably just the value
# below, but make sure you adjust if you sync to staging / demo sites.
export base_url_local=http://localhost:3000/
