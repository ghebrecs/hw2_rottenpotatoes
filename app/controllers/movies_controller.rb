 
class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # instance variable of all_ratings 
    @all_ratings = ['G','PG','PG-13','R','NC-17']

  #puts ("@@@@@@@@@@@@@@@@@@@@@@@@@@")  

    if request.query_string.length > 0 # "" if the length is 

      if params[:commit] then 

        @ratings = params[:ratings] ? params[:ratings] : {}
        @hilite = params[:sort]

      else
    
        @ratings = params[:ratings] ?
          params[:ratings] :
          session[:filter] ? session[:filter] : {}
        @hilite = params[:sort] ?
          params[:sort] :
          session[:sort] ? session[:sort] : nil
          session[:go_to] = request.url
      end

    else

      @ratings = session[:filter] ? session[:filter] : {}
      @hilite = session[:sort] ? session[:sort] : nil
      #puts("ssssssssssssssssssssssssss")
      redirect_to session[:go_to]  #movies_path(@hilite, @ratings)
    end

    @selected = @ratings.keys
    @movies = []

     # puts(@selected)
     # puts("ssssssssssssssssssssss")

    @movies = case params[:sort]

    when "title" then

      if @selected.empty? then
        Movie.order("title ASC")
      else
        Movie.where(:rating => @selected).order("title ASC")
      end
    when "release_date" then
      if @selected.empty? then
        Movie.order("release_date ASC")
      else
        Movie.where(:rating => @selected).order("release_date ASC")
      end
    else
      if @selected.empty? then
        Movie.all
      else
        Movie.where(:rating => @selected)
      end
    end
    session[:filter] = @selected.empty? ? nil : @ratings
    session[:sort] = @hilite.nil? ? nil : @hilite 
end 

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end
  
  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
