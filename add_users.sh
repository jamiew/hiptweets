#!/bin/bash

if [ -z $1 ]; then
  echo "Specify search keyword(s) to add, comma-delimited, with no spaces"
  exit 1
fi

var="HIPTWEET_USER_IDS"
current=$(heroku config:get $var)

echo "Status quo:"
echo "$var: $current"

heroku config:set $var="$current,$1" || exit $?

echo "Done."
