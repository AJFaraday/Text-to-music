#
# Andrew James Faraday - May 2012
#
# The twitter stream script is a way to automatically feed the text-to-music algorithm from the twitter streaming api.
# A search, either default (from config.yml) or manually (from the command line) will be returned in real-time as tweets are posted and then sonified or kept in a queue (deal with by the twitter streaming api) to be sonified in turn.
#

require 'rubygems'
require 'highline/import'
require 'tweetstream' 
require 'lib/pd-connect'

# Set up a port to PureData 
pd = PureData.new
 
# Load attributes from the config file
config = YAML.load_file("config.yml")['twitter']
TWITTER_USERNAME = config['username'] if config['username'] and !config['username'].empty?
password = config['password'] if config['password'] and !config['password'].nil?
search = config['default_search'].split(' ')
# default search is set if arguments are empty
if ARGV.empty?
  SEARCH = search
else
  SEARCH = ARGV
end

# ask twitter username if not present in config
unless defined?(TWITTER_USERNAME)
  TWITTER_USERNAME = ask("Twitter Username:").chomp
end
# ask twitter password if not present in config
puts "Using twitter username '#{TWITTER_USERNAME}'."
if password.nil?
  password = ask("Enter password: ") { |q| q.echo = false }
  password = password.chomp
end
# Configure TweetStream
TweetStream.configure do |config|
  config.username = TWITTER_USERNAME
  config.password = password
  config.auth_method = :basic
end
# Set up new TweetStream client
ts = TweetStream::Client.new
# Last bits of information
#TODO catch incorrect username/password at this stage
puts 'initialization finished'
puts "search: #{SEARCH.join(', ')}" 

# Code to be run on finding a tweet matching search term.
ts.track(SEARCH) do |status|
  begin
    # Output user and source  to the console 
    puts ''
    puts "[#{status.user.screen_name}] - #{status.source}"
    # Send location to console and pure data if present
    puts "location: #{status.place.country} - #{status.place.name}" if status.place
    pd.send_location(status.place, status.geo)
    # Set and sonify tweet text, format => "[mr_bloke] this is a tweet #fail #win #woot!"
    string = "[#{status.user.screen_name}] #{status.text}"
    pd.send_string(string, 0.15)
    puts ''
  rescue => er
    # display any errors that occur while keeping the stream open.
    puts er.message
    puts er.backtrace
  end
end
  

 
