#!/bin/bash

export ADMIN_PASSWORD=[set at runtime]
export APP_HOST=https://sowash.blurve.net
export MEDIA_HOST=https://sowash.com
export FILE_ROOT=recordings/mp3
export SECRET_KEY_BASE=14ad34c8e41b17f0af6699c7abf71b52
export RAILS_ENV=production

/home/michael/.rbenv/shims/bundle exec rails s -p 8181 -b 0.0.0.0

