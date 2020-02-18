class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params.key?(:sort) # check if sort parameter is in the params hash
		  session[:sort] = params[:sort] # save to session
		elsif session.key?(:sort) 
		  params[:sort] = session[:sort] # Part 3 - remember sort requests
		  flash.keep # keep flash hash for another request
		  redirect_to movies_path(params) and return # Part 3 - new URI with appropriate parameters
		end
		@sort = session[:sort]
		if params.key?(:ratings) # check if ratings parameter is in the params hash
		  session[:ratings] = params[:ratings] # save to session
		elsif session.key?(:ratings)
		  params[:ratings] = session[:ratings] # Part 3 - remember filter-by-rating requests
		  flash.keep # keep flash hash for another request
		  redirect_to movies_path(params) and return # Part 3 - new URI with appropriate parameters
		end
		@all_ratings = Movie.all_ratings
		@checked_ratings = (session[:ratings].keys if session.key?(:ratings)) || @all_ratings # Part 2 - determine checked ratings or consider all ratings by default
    @movies = Movie.order(@sort).where(rating: @checked_ratings) # Part 1 - use the order method to return rows in sorted order. Part 2 - make sure sorted items all satisfy checked rating
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
