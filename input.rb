File.foreach( 'input' ) do |line|
 array = line.split(',')
 puts array
 puts "this is array[4]: #{array[4]}"
 Tweet.create(number_of_favorites: array[0], number_of_retweets: array[1], number_of_tweets: array[2], keyword_id: array[3], date: array[4])
end