class TwitterSearch

  def self.run(opts = {})
    @search_terms = opts[:search] || ['vhx.tv']
    @user_ids = opts[:user_ids] && opts[:user_ids].split(',') || []

    raw_tweets = Twitter::Search.new.q(search_terms).fetch
    tweets = parse_tweets(raw_tweets, chat)
    tweets
  end

  def self.search_terms
    @search_terms
  end

  def self.user_ids
    @user_ids
  end


  def self.search_query
    "track=#{CGI.escape(search_terms.join(','))}"
    query = "&follow=#{user_ids}"
  end


protected

  def self.parse_tweets(tweets, _user = nil)
    tweets.map{|tweet| parse_tweet(tweet, _user) }.compact
  end

  def self.parse_tweet(tweet, _user = nil)
    tweet.from_user ||= tweet.user.screen_name # compat shimmy

    if !_user.nil?
      user = _user
    elsif  tweet.from_user.downcase == self.voice_of_god
      user = User.where(:nickname => tweet.from_user, :kind => 'system').first
      user = User.create!(:nickname => tweet.from_user, :kind => 'system') if user.nil?
    else
      user = User.where(:nickname => tweet.from_user, :kind => 'twitter').first
      user = User.create!(:nickname => tweet.from_user, :kind => 'twitter') if user.nil?
    end

    payload = {:message => tweet.text, :url => tweet_url(tweet)}
    payload[:user] = {:name => tweet.from_user, :nickname => tweet.from_user, :image => tweet.profile_image_url}
    Message.create!(:chat_id => chat.id, :user_id => user.id, :message => tweet.text[0..139])

    payload
  end

  def self.tweet_url(tweet)
    "http://twitter.com/#{tweet.from_user}/status/#{tweet.id}"
  end

end
