#!/bin/bash

export ADMIN_PASSWORD=va_3r-WPvb!@
export APP_HOST=https://sowash.blurve.net
export MEDIA_HOST=https://sowash.com
export FILE_ROOT=recordings/mp3
export SECRET_KEY_BASE=044f6bb9d7c624c27fcaecafad26ea3638455ffa56aaa66c8621064c7f4c01f1dcb9433c17ad44f64c71215e6fe39c87178a71c23913db15006be0ae769e56c4
export RAILS_ENV=production

/home/michael/.rbenv/shims/bundle exec rails c

