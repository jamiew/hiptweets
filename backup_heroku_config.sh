#!/bin/sh

echo "Saving old SEARCH ..."
heroku config:set HIPTWEET_SEARCH_BACKUP="$(heroku config:get HIPTWEET_SEARCH)"

echo "Saving old USER_IDS ..."
heroku config:set HIPTWEET_USER_IDS_BACKUP="$(heroku config:get HIPTWEET_USER_IDS)"

echo "Done"
exit 0
