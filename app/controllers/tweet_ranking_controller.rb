class TweetRankingController < ApplicationController
  def index
  	@tweets = Tweet.all
  	@days = Tweet.uniq.pluck(:date).sort

  end

  def show
  end
end
