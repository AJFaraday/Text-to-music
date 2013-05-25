Text to Music
=============
by Andrew Faraday

Overview
--------
A derivation of my very first ruby project, reading a string and converting it to control signals for puredata. The pure data patch recieves these via a TCP port and sends them to some short audio chains and the result is heard in sound.
This has also been plugged-in to the twitter streaming API, to sonify tweets as they come in. A sort of literal twitter. 
Watch out for rhyming and/or recurring words, you can actually hear that 'how now brown cow' rhymes. You can also get some drums sounds out of ascii characters: '\_=\_=\_\_\_=\_\!\_=\_\_\+='.

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

* Make sure you have the above programs and gems.
* Clone the git repository. (`git clone https://github.com/AJFaraday/Text-to-music.git`)
* Make a copy of the file config.yml.template called config.yml (`cp config.yml.template config.yml`)
* (Optional) Modify config.yml as required

Manual Mode
-----------
* Open ruby_interact.pd in puredata (make sure 'DSP' is checked)
* Open manual_input.rb in ruby (`ruby scripts/manual-input.rb`)
* Input a speed from 1 to 10
* Type some text and listen to the result.
* Repeat as required
* press `ctrl+c` to end the script

Twitter stream sonification
---------------------------
* Open ruby_interact.pd in puredata (make sure 'DSP' is checked)
* `ruby scripts/twitter-stream.rb`
* You will be prompted to authorise text-to-music to know who is following you.
* (After authorising text-to-music, you will be given two lines to add to config.yml, if you do this you will not need to authorise it again.)
* Watch the tweets contining 'fail' rolling in and being sonified
* To stop script press `ctrl+c` (you may have to hold it from there)
* Optionally:
    * Change the default search term in config.yml
    * use arguments to change the searched for terms (e.g. `ruby scripts/twitter-stream.rb win` or `ruby scripts/twitter-stream.rb right wrong`)

RSS feed sonification
---------------------

By default, the rss feed will sonify the first 5 items of a feed, then begin again when an item is added.
Initially developed and tested with the bbc news headlines feed, other rss feeds may be structured differently

* Open ruby_interact.pd in puredata (make sure 'DSP' is checked)
* `ruby scripts/rss-feed.rb`
* Optionally:
  * Set a different rss feed by changing the default feed in config.yml
  * Set a different feed as an argument (e.g. `ruby scripts/rss-feed.rb http://feeds.bbci.co.uk/news/rss.xml`)

Github commit review
--------------------

This will sonify all the commits in a github repository (currently, master branch)
starting with the most recent.

* Open ruby_interact.pd in puredata (make sure 'DSP' is checked)
* `ruby scripts/github-commits.rb`
* Optionally:
  * Set a different repo (in the style 'username/repository') in config.yml
  * Set a differnet repo as an argument (e.g. `ruby scripts/github-repo.rb rails/rails`)


Reading a file
--------------

* Open ruby_interact.pd in pure data (make sure 'DSP' is checked)
* `ruby scripts/manual-input.rb` followed by a file name (e.g. `ruby scripts/manual-input.rb README.md` will read this file)

Future intentions
-----------------
* Connect to Pidgin or IRC, musical chat client. 
* Find a library for midi output, to feed a hardware synthesizer.
* Use location information from tweets (longitude and latitude) to make repeatable timbral changes to tweets.
* Alternative pure data patches, providing a kind of 'audio skinning' (this will require a restructure of the pure data patch to put the TCP recieve part in an abstraction).
* find a way to automatically add oath credentials to config.yml
* Use other live-streaming text APIs to feed the algorithm:
  * National Rail real-time api ('https://datafeeds.networkrail.co.uk/ntrod/')

Contributors
------------
* Andrew Faraday
* Robin Gower
* Peter Vandenberk (https://www.github.com/pvdb)
* Abe Stanway(http://www.github.com/astanway)
* Pat Nakajima(https://www.github.com/nakajima)

Testers
-------
* Richard Knight
* Peter Shillito

Notes
-----

* The word 'potato' sounds surprisingly pleasant due to the reversed patter, 'ot' and 'to'
* I have added a vanilla mod to the pure data patch, requiring no pd-extended libraries. This can be run entirely in the commandline with `puredata -nogui ruby_interact_vanilla.pd`
