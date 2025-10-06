FROM ruby:2.7-alpine AS web

# Necessary for bundler to operate properly
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

RUN gem install bundler -v 2.4.22

RUN apk add --update --no-cache \
      bash \
      build-base \
      git \
      tzdata \
      mariadb-dev \
      imagemagick

RUN mkdir -p /app
WORKDIR /app

# Get the gem metadata, pull the gems, and *then* add the rest of the app. This
# avoids requiring a five-minute bundle build every time the app changes.
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install

# We add the app piecemeal out of paranoia. If somebody gets a webshell, they
# should only have the app, not anything from the local environment, which
# could have sensitive information (vim swap files, IDE files, local log files
# with passwords or something, etc.). TODO: consider putting all app-specific
# files in a subdir so the "metafiles" like compose.yml are totally separate
# from the web-required files.
ADD .solr_wrapper.yml /app/.solr_wrapper.yml
ADD Rakefile          /app/Rakefile
ADD app               /app/app
ADD bin               /app/bin
ADD build             /app/build
ADD config            /app/config
ADD config.ru         /app/config.ru
ADD db                /app/db
ADD lib               /app/lib
ADD package.json      /app/package.json
ADD public            /app/public
ADD solr              /app/solr
ADD spec              /app/spec
ADD test              /app/test
RUN mkdir -p /app/log /app/tmp /app/vendor

RUN EDITOR=sed rails credentials:edit

ENTRYPOINT ["/app/build/entrypoint.sh"]
