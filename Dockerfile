# Dockerfile for local development
FROM ruby:2.7.7
WORKDIR /airking_api

COPY Gemfile .
COPY Gemfile.lock .

RUN bundle install

COPY . /airking_api
