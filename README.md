# moi
[![Build Status](https://travis-ci.org/GrowMoi/moi.svg?branch=MOI-HSA-008-users-admin)](https://travis-ci.org/GrowMoi/moi)
[![Code Climate](https://codeclimate.com/github/GrowMoi/moi/badges/gpa.svg)](https://codeclimate.com/github/GrowMoi/moi)

## development

### requirements

- ruby 2.1+
- postgresql 9.3+
- phantomjs (to run specs) See [Installing phantomjs](https://github.com/teampoltergeist/poltergeist#installing-phantomjs)
- aspell (for spellchecker). If this package is not found, it just won't check. You can install on mac with homebrew: `brew install aspell --with-lang-es`

### getting started

0. after cloning & switching to app

  `$ git clone git@github.com:GrowMoi/moi.git moi-backend && cd moi-backend`

1. bundle

  `$ bundle`

2. revise database configs

  `$ cp config/database.yml.example config/database.yml`

3. create db, migrate it and seed it

  `$ bundle exec rake db:create db:migrate db:seed`

4. boot the app

  `$ bundle exec foreman start`

### resources

- [documentation](http://www.rubydoc.info/github/GrowMoi/moi/master)
- [guidelines](https://github.com/GrowMoi/moi/blob/master/guidelines.md)
- [moi-front-end](https://github.com/GrowMoi/moi-front-end)
- [api endpoints](https://moi-staging.herokuapp.com/apipie) _(depends on environment)_

### emails
we are using [mailcatcher](http://mailcatcher.me/) on dev environment

### api
we are using [apipie](https://github.com/Apipie/apipie-rails#dsl-reference) + [maruku](https://github.com/bhollis/maruku) to document our api using markdown. All endpoints should be documented. Include `Api::BaseDoc` module and use `#doc_for` if you're documenting an endpoint which method isn't defined in the controller itself

### Dev Notes
If you have installed Postgres App in your mac, you need to link the pg gem to the app, please run this command:
`gem install pg -v '0.20' -- --with-pg-config=/Applications/Postgres.app/Contents/Versions/11/bin/pg_config`