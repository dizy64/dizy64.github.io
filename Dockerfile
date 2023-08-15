FROM ruby:2.7.4-alpine

RUN apk update && apk add --virtual build-dependencies build-base nodejs

WORKDIR /app

ADD Gemfile Gemfile.lock /app/
RUN bundle install -j 8

ADD . /app

