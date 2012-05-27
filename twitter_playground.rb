require 'rubygems'
# shared connection to PureData 
require 'socket'
require 'character'
hostname = '127.0.0.1'
port = '3939'
sock = TCPSocket.open hostname, port

# Twitter streaming api gem
require 'tweetstream' 

TWITTER_USERNAME = 'marmitejunction'
puts "Using twitter username '#{TWITTER_USERNAME}', Password:"
password = gets.chomp

TweetStream.configure do |config|
  config.username = TWITTER_USERNAME
  config.password = password
  config.auth_method = :basic
end

ts = TweetStream::Client.new
puts 'initialization finished'
ts.track('fail') do |status|
  string = "[#{status.user.screen_name}] #{status.text}"
  puts ''
#  puts string
  Character.send_string(string, sock, 0.1)
end 
