require 'bundler/setup'
require 'rake'
require 'twitter_search'
require 'twitter_stream'

namespace :twitter do

  desc 'Fetch tweets from search results'
  task :search => :environment do
    tweets = TwitterSearch.run
    # TODO post them tweets to HipChat
  end

  desc 'Listen for tweets from Twitter'
  task :stream => :environment do
    # TODO
  end

end

