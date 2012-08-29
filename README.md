hiptweets
=========

Print tweets matching specific search terms to a HipChat room

Designed to run on Heroku for free.


Configuration
-------------

Locally you copy *config.sample.yml* to *config.yml* and fill things in.

On Heroku, set the following ENV vars:

* TWITTER_ACCESS_KEY
* TWITTER_SECRET_KEY
* TWITTER_CONSUMER_KEY
* TWITTER_CONSUMER_SECRET
* HIPCHAT_API_TOKEN
* HIPCHAT_ROOM

And what you actually want to search for:

* HIPTWEET_SEARCH -- comma-delimited string like vhx,foo,bar
* HIPTWEET_USER_IDS -- comma-delimited string of Twitter user IDs via [@username -> id lookup tool](http://id.twidder.info/)


e.g.

```bash
heroku config:add TWITTER_ACCESS_KEY="" TWITTER_SECRET_KEY="" TWITTER_CONSUMER_KEY="" TWITTER_CONSUMER_SECRET=""
heroku config:add HIPCHAT_API_TOKEN="" HIPCHAT_ROOM=""
heroku config:add HIPTWEET_SEARCH="vhx.tv,foobar"
heroku config:add HIPTWEET_USER_IDS="1234583,9876522"
```

HipChat room can be either name or ID

Running locally
---------------

```sh
bundle install
bundle exec rake twitter:stream
```

Or how it's run on Heroku, to test the Procfile:

```sh
gem install heroku
foreman start
```

Running on Heroku
----------------

```sh
heroku create hiptweets-jamiew --stack=cedar
heroku config:add TWITTER_ACCESS_KEY="" TWITTER_SECRET_KEY="" TWITTER_CONSUMER_KEY="" TWITTER_CONSUMER_SECRET=""
heroku config:add HIPCHAT_API_TOKEN="" HIPCHAT_ROOM=""
heroku config:add HIPTWEET_SEARCH="vhx.tv,foobar"
heroku config:add HIPTWEET_USER_IDS="1234583,9876522"
git push heroku master
heroku scale stream=1
```

You can use `heroku logs -t` to watch output



Notes
-----

* TwitterSearch is a work-in-progress
* Request: a node.js version that runs inside Hubot, and also responds to "@hubot search twitter 'my string'"

Authors
-------

* [Jamie Dubs (@jamiew)](https://github.com/jamiew)

Copyright
---------

All source code made freely available under an MIT License

Contributing
------------

* Fork the project
* Create a new branch for your feature or bugfix
* Send a pull request

Following the contributor-friendly practices of [Rubinius](http://www.programblings.com/2008/04/15/rubinius-for-the-layman-part-2-how-rubinius-is-friendly/)
and [FAT Lab](http://fffff.at),
anyone who submits a patch which is accepted is granted both commit and credit/attribution bits.




