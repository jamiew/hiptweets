hiptweets
=========

Search for or follow users on Twitter, print their tweets to a HipChat channel


Configuration
-------------

Copy and configure a config.yml, or set the following ENV vars (e.g. on Heroku):

* TWITTER_ACCESS_KEY
* TWITTER_SECRET_KEY
* TWITTER_CONSUMER_KEY
* TWITTER_CONSUMER_SECRET
* HIPCHAT_API_TOKEN
* HIPCHAT_ROOM

HipChat room can be a string or an ID

Running
-------

```
bundle exec rake twitter:stream
```

Or

```
gem install foreman
foreman start
```

Authors
-------

* (Jamie Dubs)[https://github.com/jamiew]

Copyright
---------

All source code made freely available under an MIT License

