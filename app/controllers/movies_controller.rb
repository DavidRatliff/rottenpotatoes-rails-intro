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
    sort_by = params[:sort_by] || session[:sort_by]
    if sort_by == 'title'
      @title_header = 'hilite'
    elsif sort_by == 'release_date'
      @release_date_header = 'hilite'
    end
    
    @all_ratings = Movie.all_ratings
    @sel_ratings = params[:ratings] || session[:ratings] || {}
    if @sel_ratings == {}
      @sel_ratings = Hash[@all_ratings.map {|rating| [rating, 1]}]
    end
    
    if params[:sort_by] != session[:sort_by] or params[:ratings] != session[:ratings]
      session[:sort_by] = params[:sort_by]
      session[:ratings] = params[:ratings]
      flash.keep
      redirect_to :sort_by => sort_by, :ratings => @sel_ratings and return
    end
    
    @movies = Movie.with_ratings(@sel_ratings.keys).order(sort_by)
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
