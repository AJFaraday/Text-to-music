#
# Andrew James Faraday - May 2012
#
# The PureData class handles the connection to the bundled pure data patch. One instance of PureData can be used multiple times.
#

require 'socket'
require 'lib/character'
require 'yaml'

class PureData

  attr_accessor :connection
  attr_accessor :hostname
  attr_accessor :port

  # 
  # Initializing an instance of PureData will set up a connection(TCPSocket) to the pure data patch. 
  # This should handle the lack of a config file, the patch being closed and an invalid hostname and/or port
  #
  def initialize
    begin
      config = YAML.load_file("config.yml")['connection']
    rescue
      puts "config.yml not found, please copy it from the template and modify as required. (`cp config.yml.template config.yml`)"
      abort
    end
    hostname = config['hostname']
    port = config['port']
    begin
      self.connection = TCPSocket.open hostname, port
      puts "Connection established on #{hostname}:#{port}"
    rescue Errno::ECONNREFUSED
      puts "Connection refused! Please ensure ruby_interact.pd is running in puredata and listening on #{hostname}:#{port}"
      abort
    rescue SocketError
      puts "Hostname and port are invalid. Please make sure they're a valid ip address and port number."
      abort
    end
  end

  #
  # Accepts a string and separates it into it's individual characters and a speed (actually a rest time in seconds)
  # Outputs characters to the console one by one (typewriter effect)
  # Outputs suitable commands to the pure data patch
  # 
  def send_string(string,speed)
    string.chars.each do |c|
      print c
      connection.puts Character.command(c)
      $stdout.flush
      sleep speed
    end
  end

  #
  # accepts the 'place' and 'geo' hashes from a tweet (TweetStream::Hash) and dumps parts of it to puredata
  # command will be along the lines of "location GB Guildford 51.24008618 -0.57108614"
  # This is intended to be used as timbre control, providing a noticable tone difference based on location. 
  # 
  def send_location(place, geo)
    if place and !place.nil?
      if geo and !geo.nil?
        # TODO add an extra case to average the boundary co-ordinates from place in the absence of geo
        connection.puts("location #{place[:country_code]} #{place[:name]} #{geo[:coordinates][0]} #{geo[:coordinates][1]};")
      end
    else
      connection.puts("location reset;")
    end
  end

end
