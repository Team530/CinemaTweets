class MoviesController < ApplicationController
    before_action :set_movie, only: [:show, :edit, :update, :destroy]
    helper_method :convert_to_dollars
    # GET /movies
    # GET /movies.json
    def index
        @movies = Movie.all
    end

    # GET /movies/1
    # GET /movies/1.json
    def show
        @movie = Movie.find(params[:id])
        @genres = @movie.genres
         keyword = Keyword.first
        tweets = Tweet.order('date asc')
        days_arr =  tweets.where(keyword_id: keyword.id).select(:date).map(&:date)
        @days = days_arr.map {|item| item=item.strftime "%Y-%m-%d"}
        movies = FinancialDatum.order('date asc').where("date >= ?", @days[0])
        @movie_gross = movies.where(movie_id: @movie.id).select(:gross_earnings).map(&:gross_earnings)
        @movie_theater = movies.where(movie_id: @movie.id).select(:num_theaters).map(&:num_theaters)
    end

    # GET /movies/new
    def new
        @movie = Movie.new
    end

    # GET /movies/1/edit
    def edit
    end

    # POST /movies
    # POST /movies.json
    def create
        @movie = Movie.new(movie_params)

        respond_to do |format|
            if @movie.save
                format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
                format.json { render :show, status: :created, location: @movie }
            else
                format.html { render :new }
                format.json { render json: @movie.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /movies/1
    # PATCH/PUT /movies/1.json
    def update
        respond_to do |format|
            if @movie.update(movie_params)
                format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
                format.json { render :show, status: :ok, location: @movie }
            else
                format.html { render :edit }
                format.json { render json: @movie.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /movies/1
    # DELETE /movies/1.json
    def destroy
        @movie.destroy
        respond_to do |format|
            format.html { redirect_to movies_url, notice: 'Movie was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_movie
        @movie = Movie.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movie_params
        params.fetch(:movie, {})
    end

    def convert_to_dollars(amount)
      if amount == 0
         return "-"
      end
      rev = amount.to_s.reverse
      temp = ""
      for i in 0 ... rev.size
         if i% 3  == 0 && i != 0
            temp <<  ',' + rev[i]
         else
            temp << rev[i]
         end
      end
      temp << "$"
      ret = temp.reverse
    end
end
