Text to Music
=============
by Andrew Faraday

Overview
--------

A derivation of my very first Ruby project: reading a string and converting it to control signals for Pure Data. The Pure Data patch receives these via a TCP port and sends them to some short audio chains and the result is heard in sound.
This has also been plugged into the Twitter streaming API, to sonify tweets as they come in. A sort of literal Twitter.
Watch out for rhyming and/or recurring words — you can actually hear that 'how now brown cow' rhymes. You can also get some drum sounds out of ASCII characters: '\_=\_=\_\_\_=\_\!\_=\_\_\+='.

Requirements
------------

* git 
* ruby
* rubygems 
* openssl-lib
* Pure Data Extended (from www.puredata.info/downloads/pd-extended)
* Gems: (`bundle install` or `sudo gem install tweetstream highline twitter_oauth`)
    * tweetstream
    * highline
    * twitter_oauth    

Installation
------------

* Make sure you have the above programs and gems
* Clone the git repository (`git clone https://github.com/AJFaraday/Text-to-music.git`)
* Make a copy of the file config.yml.template called config.yml (`cp config.yml.template config.yml`)
* Make a copy of the file twitter.yml.template called twitter.yml (`cp twitter.yml.template twitter.yml`)
* (Optional) Modify config.yml and twitter.yml as required

Manual Mode
-----------

* Open ruby_interact.pd in puredata (make sure 'DSP' is checked)
* Run `ruby scripts/manual-input.rb`
* Input a speed from 1 to 10
* Type some text and listen to the result
* Repeat as required
* Press `ctrl+c` to end the script

Twitter real-time search sonification
-------------------------------------

* Open ruby_interact.pd in puredata (make sure 'DSP' is checked)
* Run `ruby scripts/twitter-search.rb`
* You will be prompted to authorise text-to-music to know who is following you (you should only have to do this once)
* Watch the tweets containing 'fail' rolling in and being sonified
* To stop script press `ctrl+c` (you may have to hold it from there)
* Optionally:
    * Change the default search term in config.yml
    * Use arguments to change the search terms (e.g. `ruby scripts/twitter-search.rb win` or `ruby scripts/twitter-search.rb right wrong`)

Twitter user stream sonification
--------------------------------

* Open ruby_interact.pd in puredata (make sure 'DSP' is checked)
* Run `ruby scripts/twitter-userstream.rb`
* You will be prompted to authorise text-to-music to know who is following you (you should only have to do this once)
* Listen to tweets from the accounts you follow roll in in real-time
* To stop script press `ctrl+c` (you may have to hold it from there)


RSS feed sonification
---------------------

By default, the RSS feed will sonify the first 5 items of a feed, then begin again when an item is added.
Initially developed and tested with the BBC News headlines feed, other RSS feeds may be structured differently.

* Open ruby_interact.pd in puredata (make sure 'DSP' is checked)
* Run `ruby scripts/rss-feed.rb`
* Optionally:
  * Set a different RSS feed by changing the default feed in config.yml
  * Set a different feed as an argument (e.g. `ruby scripts/rss-feed.rb http://feeds.bbci.co.uk/news/rss.xml`)

GitHub commit review
--------------------

This will sonify all the commits in a GitHub repository starting with the most recent.

* Open ruby_interact.pd in puredata (make sure 'DSP' is checked)
* Run `ruby scripts/github-commits.rb`
* Optionally:
  * Set a different repo (in the style 'username/repository')
    * in config.yml (github: repo: )
    * as an argument (e.g. `ruby scripts/github-commits.rb rails/rails`)
  * Set a different branch:
    * in config.yml (github: branch: )
    * as an argument, after the repo (e.g. `ruby scripts/github-commits.rb rails/rails master`)


GitHub live commits
-------------------

This will sonify commits of a GitHub repository in real-time.

* Open ruby_interact.pd in puredata (make sure 'DSP' is checked)
* Run `ruby scripts/github-realtime.rb`
* Optionally:
  * Set a different repo (in the style 'username/repository')
    * in config.yml (github: repo: )
    * as an argument (e.g. `ruby scripts/github-realtime.rb rails/rails`)
  * Set a different branch:
    * in config.yml (github: branch: )
    * as an argument, after the repo (e.g. `ruby scripts/github-realtime.rb rails/rails master`)
  * Change the time (in seconds) between checks in config.yml (github: polling_time:)

Limitations
-----------

If you can find solutions to these problems, feel free to fix them.

* If this ran for a long time, there would be a huge array of used commit ids in memory, which could slow your computer down. Perhaps some garbage collection here when unused_ids gets past a given point.
* This is currently making a request for the whole RSS feed every minute. This seems like a lot of traffic. Is there a way to poll for just the feed version or most recent post time?

Reading a file
--------------

* Open ruby_interact.pd in puredata (make sure 'DSP' is checked)
* Run `ruby scripts/manual-input.rb` followed by a file name (e.g. `ruby scripts/manual-input.rb README.md` will read this file)

Future intentions
-----------------

* Connect to Pidgin or IRC, musical chat client. 
* Find a library for MIDI output, to feed a hardware synthesizer.
* Use location information from tweets (longitude and latitude) to make repeatable timbral changes to tweets.
* Alternative Pure Data patches, providing a kind of 'audio skinning' (this will require a restructure of the Pure Data patch to put the TCP receive part in an abstraction).
* Find a way to automatically add OAuth credentials to config.yml
* Use other live-streaming text APIs to feed the algorithm:
  * National Rail real-time API (https://datafeeds.networkrail.co.uk/ntrod/)

Contributors
------------

* Andrew Faraday
* Robin Gower
* [Peter Vandenberk](https://www.github.com/pvdb)
* [Abe Stanway](https://www.github.com/astanway)
* [Pat Nakajima](https://www.github.com/nakajima)
* [Jeremy Wentworth](https://www.github.com/jeremywen)

Testers
-------

* Richard Knight
* Peter Shillito

Notes
-----

* The word 'potato' sounds surprisingly pleasant due to the reversed patter, 'ot' and 'to'
* I have added a vanilla mod to the Pure Data patch, requiring no pd-extended libraries. This can be run entirely in the command line with `puredata -nogui ruby_interact_vanilla.pd`
