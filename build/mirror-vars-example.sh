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
