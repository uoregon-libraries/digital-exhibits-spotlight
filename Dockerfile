FROM ruby:2.7-alpine3.15 as bundler

# Necessary for bundler to operate properly
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN gem install bundler

FROM bundler as dependencies

RUN apk add --update --no-cache \
      bash \
      build-base \
      git \
      nodejs \
      sqlite-dev \
      tzdata \
      mariadb-dev \
      imagemagick6-dev imagemagick6-libs \
      nano

RUN mkdir -p /app
WORKDIR /app
ADD . /app

RUN bundle install 
