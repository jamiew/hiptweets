require 'twitter/json_stream'
require 'json'
require 'hipchat-api'

class TwitterStream

  def initialize(query)
    self.search_query = query

    # Configuration sanity checks
    if query.nil? || query.empty?
      STDERR.puts "*** Error, you must specify a search query"
      exit 1
    elsif oauth_config[:consumer_key].nil? || oauth_config[:access_key].nil?
      STDERR.puts "*** Error, incomplete Twitter OAuth configuration"
      STDERR.puts "*** Currently: #{oauth_config.inspect}"
      exit 1
    end
  end

  def search_query
    @search_query
  end

  def search_query=(query)
    @search_query = query.kind_of?(Array) ? query : query.split(',')
  end

  def user_ids
    @user_ids
  end

  def user_ids=(ids)
    @user_ids = query.kind_of?(Array) ? ids : ids.split(',')
  end

  def oauth_config
    {
      consumer_key: ENV['CONSUMER_KEY'] || Twitter.consumer_key,
      consumer_secret: ENV['CONSUMER_SECRET'] || Twitter.consumer_secret,
      access_key: ENV['ACCESS_KEY'] || Twitter.oauth_token,
      access_secret: ENV['ACCESS_SECRET'] || Twitter.oauth_token_secret,
    }
  end

  def run
    puts "Tweetscan launching..."; $stdout.flush

    escaped_query = "track=#{CGI.escape(search_query.join(','))}"
    escaped_query += "&follow=#{user_ids.join(',')}" unless user_ids.nil? || user_ids.empty?
    path = "/1/statuses/filter.json?#{escaped_query}"

    puts "path=#{path.inspect}"; $stdout.flush
    puts "-----"

    EventMachine::run {
      stream = Twitter::JSONStream.connect(path: path, oauth: oauth_config, ssl: true)

      stream.each_item do |item|
        json = JSON.parse(item)
        handle_tweet(json)
      end

      stream.on_error do |message|
        print "Tweetscan error: #{message}\n"; $stdout.flush
      end

      stream.on_reconnect do |timeout, retries|
        print "Tweetscan reconnecting in: #{timeout} seconds\n"; $stdout.flush
      end

      stream.on_max_reconnects do |timeout, retries|
        print "Tweetscan failed after #{retries} failed reconnects\n"; $stdout.flush
      end

      trap('TERM') {
        stream.stop
        EventMachine.stop if EventMachine.reactor_running?
      }
    }
  end

  def handle_tweet(status)
    tweet = status.to_openstruct
    if tweet.nil? || tweet.text.nil? || tweet.text.empty?
      STDERR.puts "Blank tweet text, skipping"
      STDERR.flush
      return
    end

    parsed_tweet = TwitterSearch.parse_tweet(tweet)
    # message = "@#{tweet.user.screen_name}: #{tweet.text}"
    message = "Match! http://twitter.com/#{tweet.from_user}/status/#{tweet.id}"
    STDOUT.puts message
    STDOUT.flush

    # Send to Hipchat
    hipchat = HipChat::API.new(HIPCHAT_CONFIG['api_token'])
    begin
      status = hipchat.rooms_message(HIPCHAT_CONFIG['room'], 'Twitter', message, 0, 'gray')
    rescue Timeout::Error
      STDERR.puts "Timeout error :-("
    end
    puts "  => #{status.inspect}"

    parsed_tweet
  end
end

