class MovieFacade
  def self.search(query, limit)
    MovieService.movie_search(query, limit)
  end

  def self.top_movies(limit)
    MovieService.top_movies(limit)
  end

  def self.movie_information(api_movie_id)
    MovieService.movie_information(api_movie_id)
  end

  def self.create_movie(api_id)
    Movie.find_or_create_by!(api_id: api_id)
  end

  def self.trending_movies(limit)
    MovieService.trending_movies(limit)
  end

  def self.create_movie_openstruct(movie_info)
    OpenStruct.new({  api_id: movie_info[:id],
                      title: movie_info[:title],
                      vote_average: movie_info[:vote_average] })
  end

  def self.create_movie_details_openstruct(movie_info)
    OpenStruct.new({ api_id: movie_info[:id],
                     title: movie_info[:title],
                     vote_average: movie_info[:vote_average],
                     runtime: movie_info[:runtime],
                     genres: MovieFacade.genre_presnetor(movie_info[:genres]),
                     summary: movie_info[:overview],
                     cast: MovieService.movie_info_cast(movie_info[:id]),
                     reviews: MovieService.movie_info_reviews(movie_info[:id]),
                     poster_path: movie_info[:poster_path] })
  end
  def self.genre_presnetor(genres)
    unless genres.nil?
      genres.map do |genre|
        genre[:name]
      end
    end
  end
end
