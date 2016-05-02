class GenreAnalysisController < ApplicationController
  def index

  	 @days = Tweet.uniq.pluck(:date).sort

  	sql = "select * from tweets where date in (Select date from tweets group by date order by date desc) order by number_of_tweets desc;"

	@tweets = ActiveRecord::Base.connection.execute(sql)
	@top_ten_tweets = []
	for item in @tweets
  		@top_ten_tweets.push(tweets.where("date = ?", item).limit(10))
  	end
  	

  end
end
