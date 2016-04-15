File.foreach( 'tweetinput' ) do |line|
 array = line.split(',')
 puts array
 puts "this is array[4]: #{array[4]}"
 Tweet.create(number_of_favorites: array[0], number_of_retweets: array[1], number_of_tweets: array[2], keyword_id: array[3], date: array[4])
end


File.foreach( 'movieinput' ) do |line|
 array = line.split(',')
 puts array
 puts "this is array[4]: #{array[4]}"
 FinancialDatum.create(number_theaters: array[0], gross_earnings: array[1], movie_id: array[2], date: array[3])
end