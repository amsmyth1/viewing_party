class MoviesController < ApplicationController
  def index
    if params[:form] == 'top_forty'
      @top_movies = MovieFacade.top_movies(40)
    elsif !params[:movie_query].nil?
      @query_results = MovieFacade.search(params[:movie_query].downcase, ENV['SEARCH_RESULT_COUNT'].to_i)
    end
    # @trending_movies = MovieFacade.trending_movies(10)
  end

  def show
    @movie_info = MovieFacade.movie_information(params[:id])
    @movie = MovieFacade.create_movie(params[:id])
    cookies[:bdseivom_di] = @movie_info.api_id
    cookies[:seivom_di] = @movie.id
    cookies[:seivom_eltit] = @movie_info.title
  end


  # def index
  #   if params[:form] == 'top_forty'
  #     @top_movies = MovieService.new.top_forty_movies
  #   elsif !params[:movie_query].nil?
  #     movie_service = MovieService.new
  #     query = params[:movie_query].downcase
  #     @query_results = movie_service.movie_search(query)
  #   end
  # end
  #
  # def show
  #   movie_service = MovieService.new
  #   @movie_info = movie_service.movie_information(params[:id])
  #   # cookies[:movie_title] = @movie_info[:title]
  #   # cookies[:duration] = @movie_info[:runtime]
  #   cookies[:seivom_di] = @movie_info[:api_id]
  #
  #   if Movie.exists?(api_id: params[:id])
  #     @movie = Movie.find_by(api_id: params[:id])
  #   else
  #     @movie = Movie.create({api_id: params[:id]})
  #   end
  # end
end
