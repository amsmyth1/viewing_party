class PartyFacade
  def self.movie_information(api_movie_id)
    MovieService.movie_information(api_movie_id)
  end

  def self.create_party(movie_info, movie_id, params, user_id)
    Party.new({ movie_id: movie_id,
                movie_title: movie_info.title,
                duration: params[:duration],
                date: params[:date],
                user_id: user_id })
  end
end
