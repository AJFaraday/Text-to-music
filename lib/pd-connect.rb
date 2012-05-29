require 'socket'
require 'lib/character'

class PureData

  attr_accessor :connection
  attr_accessor :hostname
  attr_accessor :port

  # this should set up a port into pd
  def initialize
    hostname = '127.0.0.1'
    port = '3939'
    begin
      puts "Connection established on #{hostname}:#{port}"
      self.connection = TCPSocket.open hostname, port
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
