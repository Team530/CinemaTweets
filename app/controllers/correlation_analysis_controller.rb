class CorrelationAnalysisController < ApplicationController
  def index
  	@days = Tweet.uniq.pluck(:date).sort
  	@days_format = @days.map {|item| item=item.strftime "%Y-%m-%d"}

  	@tweets = Tweet.order("date ASC, number_of_tweets DESC")
	@finance = FinancialDatum.order("date ASC, daily_gross DESC")

	@top_ten_tweets = []
	@top_ten_finance = []
	@movie_count = Array.new(@days.count, 0)
	i = 0
	puts @days.count
	@days.each do |day|
		i = i+1
		#temp = @tweets.where(["date = ?", item]).limit(10)
		tweet_movie = []
  		tweet_data = @tweets.where("date = ?", day).limit(10).pluck(:keyword_id)
  		tweet_data.each do |data|
  			movie_id = Keyword.find(data).movie_id
  			tweet_movie.push(movie_id)
  		end
  		puts "_____"
  		puts @days.count
  		puts i

  		finance_movie = @finance.where("date = ?", day).limit(10).pluck(:movie_id)
  		tweet_movie.each do |id|
  			if finance_movie.include?(id)
  				@movie_count[i] = @movie_count[i] + 1
  			end
  		end
  	end
  	
  

  end
end
