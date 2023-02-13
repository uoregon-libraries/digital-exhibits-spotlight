FROM ubuntu:bionic

RUN apt-get update

RUN apt-get install -y openjdk-8-jdk
RUN apt-get install -y imagemagick
RUN apt-get install -y mysql-client libmysqlclient-dev
RUN apt-get install -y git curl automake build-essential

# Dependencies for Ruby
RUN apt-get install -y libssl-dev libreadline-dev

# install rbenv
RUN git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv
ENV PATH /usr/local/rbenv/shims:/usr/local/rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV RBENV_ROOT /usr/local/rbenv
# install ruby-build
RUN mkdir /usr/local/rbenv/plugins
RUN git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build
RUN rbenv rehash

# Set to Ruby 2.6.5
RUN rbenv install 2.7.5
RUN rbenv rehash
RUN rbenv global 2.7.5

RUN gem install bundler

RUN mkdir /app
WORKDIR /app
ADD . /app

RUN bundle install 

