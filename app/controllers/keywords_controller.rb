class KeywordsController < ApplicationController
  before_action :set_keyword, only: [:show, :edit, :update, :destroy]

  # GET /keywords
  # GET /keywords.json
  def index
    @keywords = Keyword.all
  end

  # GET /keywords/1
  # GET /keywords/1.json
  def show
      @keyword = Keyword.find(params[:id])
      @keyword_id = @keyword.id
      tweets = Tweet.order('date asc')
      days_arr =  tweets.where(keyword_id: @keyword_id).select(:date).map(&:date)
      @days = days_arr.map {|item| item=item.strftime "%Y-%m-%d"}

      @tweets_total = tweets.where(keyword_id: @keyword_id).select(:number_of_tweets).map(&:number_of_tweets)
      @tweets_retweets = tweets.where(keyword_id: @keyword_id).select(:number_of_retweets).map(&:number_of_retweets)
      movie = Movie.find(@keyword.movie_id)
      movies = FinancialDatum.order('date asc').where("date >= ?", @days[0])
      @movie_gross = movies.where(movie_id: movie.id).select(:gross_earnings).map(&:gross_earnings)
      @movie_theater = movies.where(movie_id: movie.id).select(:num_theaters).map(&:num_theaters)


  end

  # GET /keywords/new
  def new
    @keyword = Keyword.new
  end

  # GET /keywords/1/edit
  def edit
  end

  # POST /keywords
  # POST /keywords.json
  def create
    @keyword = Keyword.new(keyword_params)

    respond_to do |format|
      if @keyword.save
        format.html { redirect_to @keyword, notice: 'Keyword was successfully created.' }
        format.json { render :show, status: :created, location: @keyword }
      else
        format.html { render :new }
        format.json { render json: @keyword.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /keywords/1
  # PATCH/PUT /keywords/1.json
  def update
    respond_to do |format|
      if @keyword.update(keyword_params)
        format.html { redirect_to @keyword, notice: 'Keyword was successfully updated.' }
        format.json { render :show, status: :ok, location: @keyword }
      else
        format.html { render :edit }
        format.json { render json: @keyword.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /keywords/1
  # DELETE /keywords/1.json
  def destroy
    @keyword.destroy
    respond_to do |format|
      format.html { redirect_to keywords_url, notice: 'Keyword was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_keyword
      @keyword = Keyword.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def keyword_params
      params.fetch(:keyword, {})
    end
end
