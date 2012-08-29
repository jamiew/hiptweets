require 'bundler/setup'
require File.expand_path('./twitter_search')
require File.expand_path('./twitter_stream')
require File.expand_path('./lib/to_openstruct')

default_search = %w{
  vhx vhx.tv
  azizansari.com indiegamethemovie.com brokenkingdomfilm.com
  starwarsuncut.com empireuncut.com
}
# @jamiew @vhxtv @starwarsuncut
default_user_ids = %w{774010 216422925 67031701}

puts "default_search=#{default_search.inspect}"
puts "default_user_ids=#{default_user_ids.inspect}"


# Load configuration globally
file = File.expand_path('./config.yml')
if File.exists?(file)
  puts "Loading credentials from config.yml ..."
  CONFIG = YAML.load(File.open(file).read)
  HIPCHAT_CONFIG = CONFIG['hipchat']
  TWITTER_CONFIG = CONFIG['twitter']

  Twitter.configure do |config|
    config.consumer_key = TWITTER_CONFIG['consumer_key']
    config.consumer_secret = TWITTER_CONFIG['consumer_secret']
    config.oauth_token = TWITTER_CONFIG['access_key']
    config.oauth_token_secret = TWITTER_CONFIG['access_secret']
  end
else
  puts "Warning, no config.yml; make sure your environment variables are set othewise"
end

# Actual tasks
namespace :twitter do

  desc 'Fetch tweets from search results'
  task :search do
    tweets = TwitterSearch.run
    # TODO post them tweets to HipChat
  end

  desc 'Listen for tweets from Twitter'
  task :stream do
    search_terms = ARGV[1] || default_search
    scanner = TwitterStream.new(search_terms, default_user_ids)
    puts "Search: #{scanner.search_query}"
    scanner.run
  end

  def post_to_hipchat(msg)
    # TODO
  end

end

