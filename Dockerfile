FROM ruby:3.3.4-alpine

RUN apk update && apk add --virtual build-dependencies build-base

WORKDIR /app

ADD Gemfile /app/
RUN bundle install -j 8

ADD . /app

CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0"]
