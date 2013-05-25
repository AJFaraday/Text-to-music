#
# Andrew James Faraday - May 2013
#
# This is an attempt to sonify github commits in real time
#

require 'lib/pd-connect'
require 'yaml'
require 'rss'

# Set up a port into pd
pd = PureData.new

# Get rss feed url
# default feed is set if arguments are empty, otherwise, the first argument is used
if ARGV.empty?
  repo = YAML.load_file("config.yml")['rss']['github']['repo']
  branch = YAML.load_file("config.yml")['rss']['github']['branch']
else
  repo = ARGV[0]
  branch = ARGV[1]
  branch ||= YAML.load_file("config.yml")['rss']['github']['branch']
end
polling_time = YAML.load_file("config.yml")['rss']['github']['polling_time']
puts "Sonifying repo: '#{repo}' branch: '#{branch}' with a delay of #{polling_time} seconds."
url = "https://www.github.com/#{repo}/commits/#{branch}.atom"
# an array of used ids, to avoid repeats

# the actual script, will find the most recent headline,
# if it's changed, the headline and description will be sent to pure data

# This collects the last 21 ids and avoids these being sonified
feed = RSS::Parser.parse(open(url).read, false)
used_ids = feed.items.collect{|item| item.id.content}

# This will check the last 20 commit ids against the used ids array
# And sonify them if they are new

loop do
  puts "Polling commits on '#{repo}' at #{Time.now.strftime('%H:%M:%S')}"

  feed.items.each do |item|
    unless used_ids.include? item.id.content
      used_ids << item.id.content
      # Selecting content from feed item
      title = item.title.content.strip
      author = item.author.name.content
      date = item.updated.content.strftime('%Y %b %d')
      content = item.content.content.gsub(/(<[^>]*>)|\n|\t/s) {" "}.strip
      # Constructing commit string
      puts("#{author}(#{date})")
      pd.send_string(content)
      2.times{puts ''}
      sleep 1
    end
  end
  # Wait ten seconds, then poll again
  sleep polling_time
  feed = RSS::Parser.parse(open(url).read, false)
end

