# default twitter username, uncomment and set name to skip typing username
# TWITTER_USERNAME = 'yourusername'
# default seach term if not set in the command line
search = ['fail']

if ARGV.empty?
  SEARCH = search
else
  SEARCH = ARGV
end

require 'rubygems'
require 'highline/import'
# Twitter streaming api gem
require 'tweetstream' 
require 'pd-connect'

# shared connection to PureData 
pd = PureData.new

if pd
  
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
  
  # The actual code for the stream
  ts = TweetStream::Client.new
  puts 'initialization finished'
  puts "search: #{SEARCH.join(', ')}" 
  
  ts.track(SEARCH) do |status|
    string = "[#{status.user.screen_name}] #{status.text}"
    puts ''
    pd.send_string(string, 0.15)
    puts ''
  end
  
else
  puts "Quit because I couldn't get a connection to PureData"
end

 
