require 'bundler/setup'

require File.expand_path('./config')
require File.expand_path('./twitter_search')
require File.expand_path('./twitter_stream')
require File.expand_path('./lib/to_openstruct')


namespace :twitter do

  desc 'Fetch tweets from search results'
  task :search do
    tweets = TwitterSearch.run(CONFIG[:search])
  end

  desc 'Listen for tweets from Twitter'
  task :stream do
    scanner = TwitterStream.new(CONFIG[:search], CONFIG[:user_ids])
    scanner.run
  end

end

