def iterateTweet
	file = File.open("TweetData", 'w')

	Tweet.all.each
	puts Tweet
	end
end


def createTweetData(fav, ret, tweets, id, date, pos, neg)
    unless Tweet.where("keyword_id = ? and date = ?", id, date).exists?
       Tweet.create(number_of_favorites: fav, number_of_retweets: ret, number_of_tweets: tweets, keyword_id: id, date: date, positive: pos, negative: neg)
    	puts "created"
    else
    	puts "exist"
    end
end

iterateTweet