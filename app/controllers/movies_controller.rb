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
    if !params[:ratings] and session[:ratings]
      if !params[:sort] and session[:sort]
        redirect_to movies_path(:sort => "#{session[:sort]}", :ratings => session[:ratings])
      else
        redirect_to movies_path(:sort => "#{params[:sort]}", :ratings => session[:ratings])
      end
    elsif !params[:sort] and session[:sort]
      redirect_to movies_path(:sort => "#{session[:sort]}", :ratings => params[:ratings])
    end
    
    
    
    @all_ratings = ['G','PG','PG-13','R']
    if params[:ratings]
      @ratings = params[:ratings]
      @include = params[:ratings].keys
      @movies = Movie.where(:rating => @ratings.keys)
      session[:ratings] = params[:ratings]
    else
      @movies = Movie.all
    end
    if @ratings == nil
      @ratings = []
      @include = @all_ratings
    end
    if params[:sort] == 'title'
      @movies = Movie.order(:title).where(:rating => @include)
      @title= 'hilite'
      session[:sort] = 'title'
    elsif params[:sort] == 'date'
      @movies = Movie.order(:release_date).where(:rating => @include)
      @date = 'hilite'
      session[:sort] = 'date'
    end
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
