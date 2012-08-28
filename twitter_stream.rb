require 'twitter/json_stream'

class TwitterStream

  def initialize(query)
    @search_query = query
    raise "You must specify a search query" if query.nil? || query.empty?
  end

  def search_query
    @search_query
  end

  def run
    puts "Tweetscan launching..."; $stdout.flush

    path = "/1/statuses/filter.json?#{search_query}"
    puts "path=#{path.inspect}"; $stdout.flush

    EventMachine::run {
      stream = Twitter::JSONStream.connect(
        :ssl => true,
        :path => path,
        :oauth => {
          :consumer_key    => ENV['CONSUMER_KEY'] || Twitter.consumer_key,
          :consumer_secret => ENV['CONSUMER_SECRET'] || Twitter.consumer_secret,
          :access_key      => ENV['ACCESS_KEY'] || Twitter.oauth_token,
          :access_secret   => ENV['ACCESS_SECRET'] || Twitter.oauth_token_secret,
        }
      )

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
    if tweet.text.blank?
      STDERR.puts "Blank tweet text, skipping"
      STDERR.flush
      return
    end

    chat = Chat.first
    raise "Tweetscan can't run without a Chat object and CHAT_ID" if chat.nil?

    parsed_tweet = TwitterWorker.parse_tweet(tweet, chat)
    STDOUT.puts "Tweetscan: pushing \"#{tweet.user.screen_name}: #{tweet.text}\"..."
    STDOUT.flush

    if parsed_tweet[:user][:nickname].downcase == TwitterWorker.voice_of_god.downcase
      puts "sending system_messages msg..."
      Pusher["presence-" + chat.channel].trigger('system_messages', parsed_tweet)
    else
      puts "sending twitter msg..."
      Pusher["presence-" + chat.channel].trigger('twitter', parsed_tweet)
    end
    parsed_tweet
  end
end

