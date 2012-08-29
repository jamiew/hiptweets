# Setup global constants with our configuration
# Freak out if required data is missing
require 'twitter'

file = File.expand_path('./config.yml')
if File.exists?(file)
  puts "Configuring using config.yml ..."
  CONFIG = YAML.load(File.open(file).read)
  HIPCHAT_CONFIG = CONFIG[:hipchat] || CONFIG['hipchat']
  TWITTER_CONFIG = CONFIG[:twitter] || CONFIG['twitter']
  CONFIG[:search] ||= ENV['HIPTWEET_SEARCH'] # From config.yml takes precedence
  CONFIG[:user_ids] ||= ENV['HIPTWEET_USER_IDS']
else
  puts "Configuring using environment variables..."
  HIPCHAT_CONFIG = { api_token: ENV['HIPCHAT_API_TOKEN'], room: ENV['HIPCHAT_ROOM'] }
  TWITTER_CONFIG = { consumer_key: ENV['TWITTER_CONSUMER_KEY'], consumer_secret: ENV['TWITTER_CONSUMER_SECRET'],
                     access_key: ENV['TWITTER_ACCESS_KEY'], access_secret: ENV['TWITTER_ACCESS_SECRET'] }
  CONFIG = { hipchat: HIPCHAT_CONFIG, twitter: TWITTER_CONFIG }
  CONFIG[:search] = ENV['HIPTWEET_SEARCH'] || 'vhx,lolwut'
  CONFIG[:user_ids] = ENV['HIPTWEET_USER_IDS'] || nil
end

# TODO should forcibly symbolize all keys

puts "HipChat: #{HIPCHAT_CONFIG.inspect}"
puts "Twitter: #{TWITTER_CONFIG.inspect}"

# We need either search terms or user_ids
if (CONFIG[:search].nil? || CONFIG[:search].empty?) && (CONFIG[:user_ids].nil? || CONFIG[:user_ids].empty?)
  STDERR.puts "*** Error, missing :search and/or :user_ids to listen for."
  exit 1
end

# HipChat config sanity check
if HIPCHAT_CONFIG.nil? || HIPCHAT_CONFIG[:api_token].nil? || HIPCHAT_CONFIG[:room].nil?
  STDERR.puts "*** Error, missing or incomplete HipChat config. Currently: #{HIPCHAT_CONFIG.inspect}"
  exit 1
end

# Check & load Twitter config
keys = [:consumer_key, :consumer_secret, :access_key, :access_secret]
keys.each do |k|
  if TWITTER_CONFIG[k].nil? || TWITTER_CONFIG[k].empty?
    STDERR.puts "*** Error, missing or incomplete Twitter config. Currently: #{TWITTER_CONFIG.inspect}"
    exit 1
  end
end

Twitter.configure do |config|
  config.consumer_key = TWITTER_CONFIG[:consumer_key]
  config.consumer_secret = TWITTER_CONFIG[:consumer_secret]
  config.oauth_token = TWITTER_CONFIG[:access_key]
  config.oauth_token_secret = TWITTER_CONFIG[:access_secret]
end
