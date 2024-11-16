FROM ruby:3.3.4-alpine

RUN apk update && apk add --virtual build-dependencies build-base

WORKDIR /app

ADD Gemfile Gemfile.lock /app/
RUN bundle install -j 8

ADD . /app

