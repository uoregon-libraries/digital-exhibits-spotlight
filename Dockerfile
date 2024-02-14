FROM ruby:2.7-alpine3.15

# Necessary for bundler to operate properly
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN gem install bundler -v 2.4.22

RUN apk add --update --no-cache \
      bash \
      build-base \
      git \
      nodejs \
      sqlite-dev \
      tzdata \
      mariadb-dev \
      imagemagick \
      nano

RUN mkdir -p /app
WORKDIR /app
ADD . /app

RUN bundle install 
