#
# Andrew James Faraday - May 2012
#

require './lib/pd-connect'
require 'yaml'
require 'rss'

# Set up a port into pd
pd = PureData.new

# Get rss feed url
# default feed is set if arguments are empty, otherwise, the first argument is used
if ARGV.empty?
  url = YAML.load_file("config.yml")['rss']['default_feed']
else
  url = ARGV[0]
end
# an array of used titles, to avoid repeats
used_titles = []
 
# the actual script, will find the most recent headline,
# if it's changed, the headline and description will be sent to pure data

puts url

loop do
  feed = RSS::Parser.parse(open(url).read, false)
  feed.items[0..9].each do |item|
    unless used_titles.include? item.title
      used_titles << item.title
      string = "#{item.title}! - #{item.description}"
      pd.send_string(string)
      2.times{puts ''}
      sleep 1
    end
  end
  sleep 10
end

