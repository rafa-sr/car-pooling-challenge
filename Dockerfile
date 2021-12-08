FROM ruby:3.0.0-alpine3.13
# This Dockerfile is optimized for go binaries, change it as much as necessary
# for your language of choice.

WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

RUN apk add --update \
  sqlite-dev

RUN apk add --no-cache bash alpine-sdk libffi-dev && \
bundle install --system --without development

ADD . /app

RUN cp config/database.yml.example config/database.yml && \
bundle exec rake db:create RACK_ENV=test && \
bundle exec rake db:migrate RACK_ENV=test && \
bundle exec rspec

EXPOSE 9091

CMD ["bundle", "exec", "rackup", "config.ru", "-p", "9091", "-o", "0.0.0.0"]
