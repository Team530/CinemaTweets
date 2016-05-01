class GenresController < ApplicationController
  before_action :set_genre, only: [:show, :edit, :update, :destroy]

  # GET /genres
  # GET /genres.json
  def index
    @genres = Genre.all
    @genre_names = @genres.pluck(:genre_name)
    @genre_counts = @genres.pluck(:count)

  end

  # GET /genres/1
  # GET /genres/1.json
  def show
     @genre = Genre.find(params[:id])
     @movies = @genre.movies
     @filtered = filter_out(@genre.genre_name, @movies)
     @filtered_genre_names = @filtered[0]
     @filtered_genre_count = @filtered[1]
  end

  # GET /genres/new
  def new
    @genre = Genre.new
  end

  # GET /genres/1/edit
  def edit
  end

  # POST /genres
  # POST /genres.json
  def create
    @genre = Genre.new(genre_params)

    respond_to do |format|
      if @genre.save
        format.html { redirect_to @genre, notice: 'Genre was successfully created.' }
        format.json { render :show, status: :created, location: @genre }
      else
        format.html { render :new }
        format.json { render json: @genre.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /genres/1
  # PATCH/PUT /genres/1.json
  def update
    respond_to do |format|
      if @genre.update(genre_params)
        format.html { redirect_to @genre, notice: 'Genre was successfully updated.' }
        format.json { render :show, status: :ok, location: @genre }
      else
        format.html { render :edit }
        format.json { render json: @genre.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /genres/1
  # DELETE /genres/1.json
  def destroy
    @genre.destroy
    respond_to do |format|
      format.html { redirect_to genres_url, notice: 'Genre was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_genre
      @genre = Genre.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def genre_params
      params.fetch(:genre, {})
    end

    def filter_out(cur_genre, movie_array)
      ret = [[],[]]
      movie_array.each do |movie|
         genre_array = movie.genres
         genre_array.each do |genre|
            if genre.genre_name != cur_genre && ret[0].include?(genre.genre_name)
               ret[0] << genre.genre_name
               ret[1] << genre.count
            end
         end
      end
      return ret
    end
end
