require 'socket'
require 'lib/character'

class PureData

  attr_accessor :connection

  # this should set up a port into pd
  def initialize
    hostname = '127.0.0.1'
    port = '3939'
    begin
      self.connection = TCPSocket.open hostname, port
    rescue Errno::ECONNREFUSED
      puts "Connection Refused! Please ensure ruby_interact.pd is running in puredata and listening on #{hostname}:#{port}"
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
