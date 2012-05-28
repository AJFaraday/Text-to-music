# default twitter username, uncomment and set name to skip typing username
# TWITTER_USERNAME = 'yourusername'
# default seach term if not set in the command line
DEFAULT_SEARCH = ['fail']

if ARGV
  SEARCH = ARGV
else
  # Default search term
  SEARCH = DEFAULT_SEARCH
end

require 'rubygems'
# shared connection to PureData 
require 'highline/import'
require 'socket'
require 'character'
hostname = '127.0.0.1'
port = '3939'
sock = TCPSocket.open hostname, port

# Twitter streaming api gem
require 'tweetstream' 

unless defined?(TWITTER_USERNAME)
  TWITTER_USERNAME = ask("Twitter Username:").chomp
end

puts "Using twitter username '#{TWITTER_USERNAME}'."
#password = gets.chomp
password = ask("Enter password: ") { |q| q.echo = false }
password = password.chomp

TweetStream.configure do |config|
  config.username = TWITTER_USERNAME
  config.password = password
  config.auth_method = :basic
end

ts = TweetStream::Client.new
puts 'initialization finished'

ts.track(SEARCH) do |status|
  string = "[#{status.user.screen_name}] #{status.text}"
  puts ''
  Character.send_string(string, sock, 0.1)
end 
