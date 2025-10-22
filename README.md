# README

This is UO's exhibit app, built on top of Spotlight

## Infrastructure

This application is expected to be run inside docker or podman containers for
both development and production. `compose.yml` defines all the services
necessary for the application to run.

Key services:

- `proxy` is an nginx proxy that caches some static content for faster
  delivery.
- `web` is the actual Rails app being served up by Puma.
- `sidekiq` runs all background jobs.

## Local dev

### Configuration

It is highly recommended that you keep `RAILS_ENV` set to *production*. The
development setup will make the edit loop faster, but so many things are
different that it can cause problematic "drift" between prod and dev.

For instance, if you're trying to figure out a performance problem, all the
caching that is only done in a prod environment will completely ruin any
benchmarking or metrics. Not that *I* would forget this, of course, but I've
heard from a friend that it can be annoying.

### Getting data

To mirror production's database, you'll need to set up `build/mirror-vars.sh`
(see the example file for variables that are needed) and then run
`build/mirror.sh`. See `mirror-vars-example.sh` for details.

*Note*: this relies on having the podman rsync stuff installed on the podman
server!

### Making Solr aware of your data

To index an exhibit, you'll need to go into a rails console, pick the exhibit,
and tell it to reindex "later":

```ruby
# Very slow: reindex everything
Spotlight::Exhibit.find_each do |e|
  e.reindex_later
end

# Less slow: pick a single exhibit to reindex
Spotlight::Exhibit.find(<id>).reindex_later
```

Note that "later" is somewhat misleading. The jobs will be sent to sidekiq
immediately, and executed as soon as sidekiq is able.

Then, making sure you have the `sidekiq` service running, go grab some coffee
or something. With the prod data, this will take a few minutes.

### Starting the stack

- Copy `compose.override.example.yml` to `compose.override.yml` and edit as
  needed. **Do not use the copied override exactly as-is!**
- Use docker compose, e.g., `docker compose up -d proxy`

### Rails console stuff to know

The "base" object type appears to be a `Spotlight::Resource`. Exhibits are
`Spotlight::Exhibit`. You can find an exhibit and its resources something like
this:

```ruby
e = Spotlight::Exhibit.find(5)
resource = Spotlight::Resource.find(e.resource_ids.first)
```

You cannot currently use `e.resources` because some resources in the database
have a model that is no longer in the codebase. Decoupling code and data is way
out of scope, but something to consider when we do major work on this again.
