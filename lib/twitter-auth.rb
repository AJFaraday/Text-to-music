require 'twitter_oauth'

def get_twitter_auth(config)

  # Load attributes from the config file
  consumer_key       = config['consumer_key'] if config['consumer_key'] and !config['consumer_key'].empty?
  consumer_secret    = config['consumer_secret'] if config['consumer_secret'] and !config['consumer_secret'].empty?
  oauth_token        = config['oauth_token'] if config['oauth_token'] and !config['oauth_token'].empty?
  oauth_token_secret = config['oauth_token_secret'] if config['oauth_token_secret'] and !config['oauth_token_secret'].empty?

  unless oauth_token and oauth_token_secret
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
    
    config['oauth_token'] = oauth_token = access_token.token
    config['oauth_token_secret'] = oauth_token_secret = access_token.secret
    
    #save the new oauth values
    File.open("twitter.yml", "w"){ |f| 
      YAML.dump(config, f)
    }

    puts 'You\'ve successfully authorised text-to-music to read your tweets and find out who you follow in order to reproduce your twitter stream with musical accompaniment. '
  end
  
  return consumer_key, consumer_secret, oauth_token, oauth_token_secret
end
