require 'bundler/setup'

require File.expand_path('./config')
require File.expand_path('./twitter_search')
require File.expand_path('./twitter_stream')
require File.expand_path('./lib/to_openstruct')

# default_search = %w{
#   vhx vhxtv vhx.tv
#   azizansari.com indiegamethemovie.com brokenkingdomfilm.com
#   starwarsuncut.com
#  }
default_search = %w{vhx.tv}

# @jamiew @vhxtv @starwarsuncut
#default_user_ids = %w{774010 216422925 67031701}
default_user_ids = []

puts "default_search=#{default_search.inspect}"
puts "default_user_ids=#{default_user_ids.inspect}"


# Actual tasks
namespace :twitter do

  desc 'Fetch tweets from search results'
  task :search do
    tweets = TwitterSearch.run
  end

  desc 'Listen for tweets from Twitter'
  task :stream do
    search_terms = ARGV[1] || default_search
    scanner = TwitterStream.new(search_terms, default_user_ids)
    puts "Search: #{scanner.search_query}"
    scanner.run
  end

end

