require 'json'
require 'pp'
require 'date'

# This is the analysis bit.
File.open('./feed_people.json') do |f|
  feed_people = JSON.parse(f.read)['users']
  feed_person = feed_people[0]
  one = feed_people.select {|foo| foo['screen_name'] && foo['status']}
  two = one.sort_by {|foo| DateTime.parse foo['status']['created_at']}
  three = two.map {|foo| foo['screen_name']}

  # pp feed_person['screen_name']
  # pp feed_person['status']
  # pp feed_person['screen_name'] && feed_person['status']

  # pp feed_people
  # pp one.length
  # pp two
  pp three.reverse
  puts three.count
end

# this pulls stuff from twitter.

require 'twitter'

Twitter.configure do |config|
  config.consumer_key = '' # get your own or ask me to automate this more
  config.consumer_secret = '' # get your own or ask me to automate this more
  config.oauth_token = '' # get your own or ask me to automate this more
  config.oauth_token_secret = '' # get your own or ask me to automate this more
end

friend_ids = Twitter.friend_ids.all
friends = []
while friend_ids.length > 0
  begin
    friends += Twitter.users(*friend_ids.take(100))
  rescue Twitter::Error::TooManyRequests => error
    while error.rate_limit.reset_in > 0
      puts "#{error.rate_limit.reset_in} seconds more until the next request..."
      sleep 15
    end
    retry
  else
    friend_ids = friend_ids.drop(100)
  end
end

