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
* Gems: (`bundle install`)
    * tweetstream
    * highline

Installation
------------

* Make sure you have the above programs and gems.
* Clone the git repository. (`git clone https://github.com/AJFaraday/Text-to-music.git`)
* Make a copy of the file config.yml.template called config.yml (`cp config.yml.template config.yml`)
* (Optional) Modify config.yml as required

Manual Mode
-----------
* Open ruby_interact.pd in puredata
* Open manual_input.rb in ruby (e.g. `ruby manual_input.rb`)
* Input a speed from 1 to 10
* Type some text and listen to the result.
* Repeat as required
* press `ctrl+c` to end the script

Twitter stream sonification
---------------------------
* Open ruby_interact.pd in puredata
* `ruby twitter.rb`
* Input a twitter username and password when requested
* Watch the tweets contining 'fail' rolling in and being sonified
* To stop script press `ctrl+c` (you may have to hold it from there)
* Optionally:
    * Add your twitter username and password to config.yml to skip manual input
    * Change the default search term in config.yml
    * use arguments to change the searched for terms (e.g. `ruby twitter.rb win` or `ruby twitter.rb right wrong`)

Future intentions
-----------------
* Connect to Pidgin or IRC, musical chat client. 
* Find a library for midi output, to feed a hardware synthesizer.

Contributors
------------
* Andrew Faraday
* Robin Gower
