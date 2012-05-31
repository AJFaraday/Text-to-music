require 'socket'
require 'lib/character'
require 'yaml'

class PureData

  attr_accessor :connection
  attr_accessor :hostname
  attr_accessor :port

  # this should set up a port into pd
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
    end
  end

  def send_string(string,speed)
    string.chars.each do |c|
      print c
      connection.puts Character.command(c)
      $stdout.flush
      sleep speed
    end
  end

  # accepts the 'place' and 'geo' hashes from a tweet and dumps parts of it to puredata
  # command will be along the lines of "location GB Guildford 51.24008618 -0.57108614"
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
