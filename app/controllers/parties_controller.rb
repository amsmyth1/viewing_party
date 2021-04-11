class PartiesController < ApplicationController

  def create
    @movie_info = PartyFacade.movie_information(cookies[:bdseivom_di])
    party = PartyFacade.create_party(@movie_info, cookies[:seivom_di], params, current_user.id)
    if party.save
      PartyFriend.create_party(party.id, params[:friends])
      redirect_to dashboard_path
    else
      flash[:error] = 'Date and duration must be selected'
      render :new
    end
  end

  def new
    @movie_info = PartyFacade.movie_information(cookies[:bdseivom_di])
  end
  # def create
  #   movie_service = MovieService.new
  #   movie = Movie.find_by(api_id: cookies[:seivom_di])
  #   @movie_info = movie_service.movie_information(movie.api_id)
  #
  #   party = Party.new({
  #                     movie_id:  movie.id,
  #                  movie_title:  @movie_info[:title],
  #                     duration:  params[:duration],
  #                     date:  params[:date],
  #                      user_id:  current_user.id
  #                       })
  #   if party.save
  #     redirect_to dashboard_path
  #     if params[:friends] != nil
  #       PartyFriend.create_party(party.id, params[:friends])
  #     end
  #   else
  #     flash[:error] = "Date and duration must be selected"
  #     render :new
  #   end
  # end

  # def new
  #   movie_service = MovieService.new
  #   @movie_info = movie_service.movie_information(cookies[:seivom_di])
  # end
end
