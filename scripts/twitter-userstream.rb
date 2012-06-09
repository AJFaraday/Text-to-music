#
# Andrew James Faraday - May 2012
#
# The twitter stream script is a way to automatically feed the text-to-music algorithm from the twitter userstream api.
# A users stream will be returned in real-time as tweets are posted and then sonified or kept in a queue (deal with by the twitter streaming api) to be sonified in turn.
#

require 'rubygems'
require 'tweetstream' 
require 'lib/pd-connect'
require 'twitter_oauth'

config = YAML.load_file("config.yml")['twitter']
consumer_key       = config['consumer_key'] if config['consumer_key'] and !config['consumer_key'].empty?
consumer_secret    = config['consumer_secret'] if config['consumer_secret'] and !config['consumer_secret'].empty?
oauth_token        = config['oauth_token'] if config['oauth_token'] and !config['oauth_token'].empty?
oauth_token_secret = config['oauth_token_secret'] if config['oauth_token_secret'] and !config['oauth_token_secret'].empty?

# Set up a port to PureData 
pd = PureData.new
 
# default search is set if arguments are empty
if ARGV.empty?
  search = search
else
  search = ARGV.join ' '
end

unless oauth_token and oauth_token_secret
  client = TwitterOAuth::Client.new(:consumer_key => consumer_key,
                                    :consumer_secret => consumer_secret)
  request_token = client.request_token()
  puts "go to the browser and open this url to authorise your account: #{request_token.authorize_url}"
  puts "What pin did it give you?"
  pin = gets.chomp
  access_token = client.authorize(request_token.token,
                                  request_token.secret,
                                  :oauth_verifier => pin) 
  oauth_token = access_token.token
  oauth_token_secret = access_token.secret

  puts <<TEXT


You've successfully authorised text-to-music to read your tweets and find out who you follow in order to reproduce your twitter stream with musical accompaniment. 
In order to avoid having to go to a browser to re-authorize your account agian replace the oauth_token and oauth_token_secret lines in config.yml with these two lines

  oauth_token: #{oauth_token}
  oauth_token_secret: #{oauth_token_secret}
TEXT
end

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
#TODO catch incorrect username/password at this stage
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
    pd.send_string(string, 0.15)
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

