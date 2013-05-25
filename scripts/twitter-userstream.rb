#
# Andrew James Faraday - May 2012
#
# The twitter stream script is a way to automatically feed the text-to-music algorithm from the twitter userstream api.
# A users stream will be returned in real-time as tweets are posted and then sonified or kept in a queue (deal with by the twitter streaming api) to be sonified in turn.
#

require 'rubygems'
require 'tweetstream' 
require './lib/pd-connect'
require './lib/twitter-auth'

config = YAML.load_file("twitter.yml")

# Set up a port to PureData 
pd = PureData.new
 
consumer_key, consumer_secret, oauth_token, oauth_token_secret = get_twitter_auth(config)

# Configure TweetStream
TweetStream.configure do |config|
  config.consumer_key       = consumer_key
  config.consumer_secret    = consumer_secret
  config.oauth_token        = oauth_token
  config.oauth_token_secret = oauth_token_secret
  config.auth_method        = :oauth
end

# Set up new TweetStream client
ts = TweetStream::Client.new
# Last bits of information
puts 'initialization finished'

# Code to be run on finding a tweet matching search term.
ts.on_timeline_status do |status|
  begin
    # Output user and source  to the console 
    puts ''
    puts "[#{status.user.screen_name}] - #{status.source}"
    # Send location to console and pure data if present
    puts "location: #{status.place.country} - #{status.place.name}" if status.place
    pd.send_location(status.place, status.geo)
    # Set and sonify tweet text in this format: "[mr_bloke] this is a tweet #fail #win #woot!"
    string = "[#{status.user.screen_name}] #{status.text}"
    pd.send_string(string)
    puts ''
  rescue => er
    # display any errors that occur while keeping the stream open.
    puts er.message
    puts er.backtrace
  end
end

ts.on_error do |error|
  puts "ERROR: #{error}"
end
  
ts.userstream

