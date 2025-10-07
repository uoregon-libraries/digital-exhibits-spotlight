# README

This is UO's exhibit app, built on top of Spotlight

## Infrastructure

This application is expected to be run inside docker or podman containers for
both development and production. `compose.yml` defines all the services
necessary for the application to run.

Key services:

- `web` is an nginx proxy that caches some static content for faster delivery. To
  simplify migrating from the pre-nginx varsion of this app, the name "web" was
  chosen to keep muscle-memory working for those naming the service directly,
  e.g., `docker compose up -d web`.
- `app` is the actual Rails app being served up by Puma.
- `sidekiq` runs all background jobs.

## Local dev

The easy instructions:

- Copy `compose.override.example.yml` to `compose.override.yml` and edit as
  needed. **Do not use the copied override exactly as-is!**
- Use docker compose, e.g., `docker compose up -d web`
- Watching logs? Remember that `web` is nginx: it's useful for watching the
  actual incoming requests, but `app` is where you'll see application-level
  error logs.
