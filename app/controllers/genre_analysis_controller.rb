class GenreAnalysisController < ApplicationController
   def index

      @days = Tweet.uniq.pluck(:date).sort

      #	sql = "select * from tweets where date in (Select date from tweets group by date order by date desc) order by number_of_tweets desc;"

      #@tweets = ActiveRecord::Base.connection.execute(sql)
      @tweets = Tweet.order("date ASC, number_of_tweets DESC")
      @finance = FinancialDatum.order("date ASC, daily_gross DESC")

      @top_ten_tweets = []
      @top_ten_finance = []
      for item in @days
         puts item
         #temp = @tweets.where(["date = ?", item]).limit(10)
         @top_ten_tweets.push(@tweets.where("date = ?", item).limit(10))
         @top_ten_finance.push(@finance.where("date = ?", item).limit(10))

      end

      @filtered_genre_names = Genre.order(:id).pluck(:genre_name)
      @genre_arr = Array.new(19,0)
      @genre_arr2 = Array.new(19,0)

      #genre_arr
      @top_ten_tweets.each do |tweet_data|
         tweet_data.each do |tweet|
            keyword = Keyword.find(tweet.keyword_id)
            movie = Movie.find(keyword.movie_id)
            GenreTag.where("movie_id = ?", keyword.movie_id).each do |genre|
               puts genre.genre_id
               @genre_arr[genre.genre_id-1] = @genre_arr[genre.genre_id-1] + 1
               #movie genre
            end
         end
      end

      @top_ten_finance.each do |finance_data|
         finance_data.each do |finance|
            movie = Movie.find(finance.movie_id)
            GenreTag.where("movie_id = ?", finance.movie_id).each do |genre|
               puts genre.genre_id
               @genre_arr2[genre.genre_id-1] = @genre_arr2[genre.genre_id-1] + 1
               #movie genre
            end
         end
      end


   end
end
