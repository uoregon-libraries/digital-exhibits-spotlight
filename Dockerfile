FROM ruby:2.7-alpine AS web

# Necessary for bundler to operate properly
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

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
ADD . /app

ENTRYPOINT ["/app/build/entrypoint.sh"]
