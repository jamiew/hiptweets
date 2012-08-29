require 'twitter/json_stream'
require 'json'
require 'hipchat-api'

class TwitterStream

  def initialize(query, user_ids=nil)
    self.search_query = query
    self.user_ids = user_ids

    # Configuration sanity checks
    if query.nil? || query.empty?
      STDERR.puts "*** Error, you must specify a search query"
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
    @user_ids = ids.kind_of?(Array) ? ids : (ids && ids.split(','))
  end

  def oauth_config
    {
      consumer_key: Twitter.consumer_key,
      consumer_secret: Twitter.consumer_secret,
      access_key: Twitter.oauth_token,
      access_secret: Twitter.oauth_token_secret,
    }
  end

  def run
    puts "TwitterStream launching..."; $stdout.flush

    escaped_query = "track=#{search_query.map{|s| CGI.escape(s) }.join(',')}"
    escaped_query += "&follow=#{user_ids.join(',')}" unless user_ids.nil? || user_ids.empty?
    path = "/1/statuses/filter.json?#{escaped_query}"

    puts "path=#{path.inspect}"; $stdout.flush
    puts "-----"

    EventMachine::run {

      # TODO add an on_connect handler to Twitter::JSONStream and send a friendly pull request
      on_connect = lambda {
        print "TwitterStream connected. Listening for da tweets... \n"; $stdout.flush
      }

      # Connect
      stream = Twitter::JSONStream.connect(path: path, oauth: oauth_config, ssl: true, on_inited: on_connect)

      # Callbacks
      stream.each_item do |item|
        json = JSON.parse(item)
        handle_tweet(json)
      end

      stream.on_error do |message|
        print "TwitterStream error: #{message}\n"; $stdout.flush
      end

      stream.on_close do |message|
        print "TwitterStream disconnected #{message}\n"; $stdout.flush
      end

      stream.on_reconnect do |timeout, retries|
        print "TwitterStream reconnecting in: #{timeout} seconds; timeout=#{timeout.inspect}\n"; $stdout.flush
      end

      stream.on_max_reconnects do |timeout, retries|
        print "TwitterStream failed after #{retries} failed reconnects; timeout=#{timeout.inspect}\n"; $stdout.flush
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
    message = "http://twitter.com/#{tweet.from_user}/status/#{tweet.id}"
    puts message; STDOUT.flush

    # Send to HipChat
    hipchat = HipChat::API.new(HIPCHAT_CONFIG[:api_token])
    status = nil
    begin
      status = hipchat.rooms_message(HIPCHAT_CONFIG[:room], 'Twitter', message, 0, 'gray', 'text')
      puts "  => #{status.inspect}"
    rescue Timeout::Error
      STDERR.puts "** Error posting to HipChat: #{$!.inspect}"; STDERR.flush
    end

    parsed_tweet
  end
end

