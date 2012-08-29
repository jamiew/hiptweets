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

e.g.

```bash
heroku config:add TWITTER_ACCESS_KEY="" TWITTER_SECRET_KEY"" TWITTER_CONSUMER_KEY="" TWITTER_CONSUMER_SECRET=""
heroku config:add HIPCHAT_API_TOKEN="" HIPCHAT_ROOM=""
```

HipChat room can be either name or ID

Running locally
---------------

```bash
bundle install
bundle exec rake twitter:stream
```

Or how it's run on Heroku, to test the Procfile:

```bash
gem install heroku
foreman start
```

Running on Heroku
----------------

```bash
heroku create hiptweets-jamiew --stack=cedar
heroku config:add TWITTER_ACCESS_KEY="" TWITTER_SECRET_KEY"" TWITTER_CONSUMER_KEY="" TWITTER_CONSUMER_SECRET=""
heroku config:add HIPCHAT_API_TOKEN="" HIPCHAT_ROOM=""
git push heroku master
heroku scale
```

You can use `heroku logs -t` to watch output



Notes
-----

* TwitterSearch is a work-in-progress
* Request: a node.js version that runs inside Hubot, and also responds to "@hubot search twitter 'my string'"

Authors
-------

* (Jamie Dubs)[https://github.com/jamiew]

Copyright
---------

All source code made freely available under an MIT License

Contributing
------------

* Fork the project
* Create a new branch for your feature or bugfix
* Send a pull request

Following the contributor-friendly practices of (Rubinius)[http://www.programblings.com/2008/04/15/rubinius-for-the-layman-part-2-how-rubinius-is-friendly/]
and (FAT Lab)[http://fffff.at],
anyone who submits a patch which is accepted is granted both commit and credit/attribution bits.




