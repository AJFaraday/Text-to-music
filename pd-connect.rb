require 'socket'
require 'character'

module PureData

  # this should set up a port into pd
  def self.connection
    hostname = '127.0.0.1'
    port = '3939'
    begin
      sock = TCPSocket.open hostname, port
      return sock
    rescue Errno::ECONNREFUSED
      puts "Connection Refused! Please ensure ruby_interact.pd is running in puredata and listening on #{hostname}:#{port}"
    end
  end

end