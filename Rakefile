require 'bundler/setup'
require File.expand_path('./twitter_search')
require File.expand_path('./twitter_stream')
require File.expand_path('./lib/to_openstruct')

default_search = %w{
  vhx vhxtv vhx.tv
  azizansari.com indiegamethemovie.com brokenkingdomfilm.com
  starwarsuncut.com
 }

# @jamiew @vhxtv @starwarsuncut
#default_user_ids = %w{774010 216422925 67031701}
default_user_ids = []

puts "default_search=#{default_search.inspect}"
puts "default_user_ids=#{default_user_ids.inspect}"

# Load configuration globally
file = File.expand_path('./config.yml')
if File.exists?(file)
  puts "Configuring using config.yml ..."
  config = YAML.load(File.open(file).read).symbolize_keys
  HIPCHAT_CONFIG = config[:hipchat]
  TWITTER_CONFIG = config[:twitter]
else
  puts "Configuring using environment variables..."
  HIPCHAT_CONFIG = { api_token: ENV['HIPCHAT_API_TOKEN'], room: ENV['HIPCHAT_ROOM'] }
  TWITTER_CONFIG = { consumer_key: ENV['TWITTER_CONSUMER_KEY'], consumer_secret: ENV['TWITTER_CONSUMER_SECRET'],
                     access_key: ENV['TWITTER_ACCESS_KEY'], access_secret: ENV['TWITTER_ACCESS_SECRET'] }
end

puts "Twitter: #{TWITTER_CONFIG.inspect}"
puts "HipChat: #{HIPCHAT_CONFIG.inspect}"

Twitter.configure do |config|
  config.consumer_key = TWITTER_CONFIG[:consumer_key]
  config.consumer_secret = TWITTER_CONFIG[:consumer_secret]
  config.oauth_token = TWITTER_CONFIG[:access_key]
  config.oauth_token_secret = TWITTER_CONFIG[:access_secret]
end


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

