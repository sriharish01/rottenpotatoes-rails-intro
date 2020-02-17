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
    @all_ratings=Movie.all_ratings
    
    #redirect flag is used to indicate if a url should be redirected according to session values
    redirectFlag=0
    
    if params[:order]
      @orderList=params[:order]
    else
      @orderList=session[:order]
    end
    
    #setting redirect flag if param value is not present
    if (params[:order]==nil && session[:order]!=nil)
      redirectFlag=1
    end
    
    #updating session
    if params[:order]!= session[:order]
      session[:order]=@orderList
    end
    if @orderList=="title"
      @movies=Movie.all.order(@orderList)
      @highlight_title = "hilite"
    elsif @orderList=="release_date"
      @movies=Movie.all.order(@orderList)
      @highlight_date = "hilite"
    else
    @movies = Movie.all
    end
    
    #filtering the movies
    if params[:ratings]
      @ratings=params[:ratings]
      @movies=@movies.where(rating: @ratings.keys)
    else
      if session[:ratings]
        @ratings=session[:ratings]
        @movies=@movies.where(rating: @ratings.keys)
        redirectFlag=1 #setting redirect flag if param value is not present
      else
        @ratings=Hash[@all_ratings.collect {|rating| [rating, rating]}] #setting rating to all ratings as initially all boxes should be checked
        @movies=@movies
      end
    end
    #updating session 
    if @ratings != session[:ratings]
      session[:ratings]=@ratings
    end
    #redirecting the url according to the values in the session variable if there is no parameter values
    if redirectFlag==1
      flash.keep
      redirect_to movies_path(order: session[:order],ratings: session[:ratings])
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
