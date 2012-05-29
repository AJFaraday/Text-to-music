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
      raise "config.yml not found, please copy it from the template and modify as required. (`cp config.yml.template config.yml`)"
      return
    end
    hostname = config['hostname']
    port = config['port']
    begin
      self.connection = TCPSocket.open hostname, port
      puts "Connection established on #{hostname}:#{port}"
    rescue Errno::ECONNREFUSED
      puts "Connection refused! Please ensure ruby_interact.pd is running in puredata and listening on #{hostname}:#{port}"
    end
  end

  def send_string(string,speed)
    string.chars.each do |c|
      print c
      connection.puts Character.new(c).command
      $stdout.flush
      sleep speed
    end
  end

end
