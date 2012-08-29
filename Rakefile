require 'bundler/setup'

require File.expand_path('./config')
require File.expand_path('./twitter_search')
require File.expand_path('./twitter_stream')
require File.expand_path('./lib/to_openstruct')


# Array or comma-delimited string like "mudkips, lolruses, how do i shot web"
# TODO load these from/in config.rb too
search_terms = ENV['HIPTWEET_SEARCH'] || 'lolwut'
puts "default_search=#{default_search.inspect}"

# Array or comma-delimited string of Twitter user IDs
# Use http://id.twidder.info/ to lookup from usernames
user_ids = ENV['HIPTWEET_USER_IDS'] || []
puts "default_user_ids=#{default_user_ids.inspect}"


# Actual tasks
namespace :twitter do

  desc 'Fetch tweets from search results'
  task :search do
    tweets = TwitterSearch.run(search_terms)
  end

  desc 'Listen for tweets from Twitter'
  task :stream do
    search_terms = ARGV[1] || default_search
    scanner = TwitterStream.new(search_terms, default_user_ids)
    puts "Search: #{scanner.search_query}"
    scanner.run
  end

end

