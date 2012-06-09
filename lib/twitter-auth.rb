require 'twitter_oauth'

def get_twitter_auth(consumer_key, consumer_secret)
  puts 'HGHHHHHHHHHH'
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
  return oauth_token, oauth_token_secret
end
