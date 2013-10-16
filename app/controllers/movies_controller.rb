 #references
# ----------
#> [Ruby on Rail Tutorial by Michael Hurtl]: http://ruby.railstutorial.org/
#> [edx]: https://courses.edx.org/courses/BerkeleyX/CS-169.1x/2013_Summer/courseware/Week_3x/Homework_2/
#> [youtube lecture]: http://www.youtube.com/watch?v=z0lf0o9cNdg
#> class TA 

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
          
      end
      session[:go_to] = request.url
    else

      @ratings = session[:filter] ? session[:filter] : {}
      @hilite = session[:sort] ? session[:sort] : nil
      redirect_to session[:go_to]  #movies_path(@hilite, @ratings)
    end
    @movies = []
    @sort = params[:sort]
    
    #@all_ratings = ["G", "PG", "PG-13", "R", "NC-17"]
    if !params[:ratings].nil?
      Movie.all.each { |value|
        if params[:ratings][value.rating] == "1"
          @movies << value
        end
      }
    end
    if @sort == "title"
      @movies.sort!{|a, b| a.title.downcase <=> b.title.downcase}
    elsif @sort == "release_date"
      @movies.sort!{|a, b| b.release_date <=> a.release_date}
    end
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
