class RatingAnalysisController < ApplicationController
  def index
  		 @days = Tweet.uniq.pluck(:date).sort
  		 @MPAA_rating = Movie.uniq.pluck(:MPAA_rating)
  #	sql = "select * from tweets where date in (Select date from tweets group by date order by date desc) order by number_of_tweets desc;"

	#@tweets = ActiveRecord::Base.connection.execute(sql)
	@tweets = Tweet.order("date ASC, number_of_tweets DESC")
	@finance = FinancialDatum.order("date ASC, daily_gross DESC")

	@top_ten_tweets = []
	@top_ten_finance = []
	for item in @days
		#temp = @tweets.where(["date = ?", item]).limit(10)
  		@top_ten_tweets.push(@tweets.where("date = ?", item).limit(10))
  		@top_ten_finance.push(@finance.where("date = ?", item).limit(10))

  	end
  	@rating_arr = Array.new(@MPAA_rating.count,0)
  	 @rating_arr2 = Array.new(@MPAA_rating.count,0)

  	#genre_arr
  	@top_ten_tweets.each do |tweet_data|
	tweet_data.each do |tweet| 
		keyword = Keyword.find(tweet.keyword_id)
		movie = Movie.find(keyword.movie_id)
		i = @MPAA_rating.index(movie.MPAA_rating)
		@rating_arr[i] = @rating_arr[i] + 1
		#movie genre
	end
      end


	@top_ten_finance.each do |finance_data|
	finance_data.each do |finance| 

		movie = Movie.find(finance.movie_id)
		i = @MPAA_rating.index(movie.MPAA_rating)
		@rating_arr2[i] = @rating_arr2[i] + 1	
		#movie genre
	end
      end

	
  end
end
