require 'rubygems'
require 'highline/import'
# Twitter streaming api gem
require 'tweetstream' 
require 'lib/pd-connect'

# shared connection to PureData 
pd = PureData.new

if pd
 
  config = YAML.load_file("config.yml")
  TWITTER_USERNAME = config['twitter']['username'] if config['twitter']['username'] and ! config['twitter']['username'].empty?
  password = config['twitter']['password'] if config['twitter']['password'] and ! config['twitter']['password'].nil?
  search = config['twitter']['default_search'].split(' ')

  if ARGV.empty?
    SEARCH = search
  else
    SEARCH = ARGV
  end

  unless defined?(TWITTER_USERNAME)
    TWITTER_USERNAME = ask("Twitter Username:").chomp
  end
  
  puts "Using twitter username '#{TWITTER_USERNAME}'."
  if password.nil?
    password = ask("Enter password: ") { |q| q.echo = false }
    password = password.chomp
  end
  
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

 
