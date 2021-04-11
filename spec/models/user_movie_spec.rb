require 'rails_helper'

RSpec.describe UserMovie, type: :model do
  before :each do
    @user = User.create(email: 'fun@email.com', password: 'test')
    @user2 = User.create!(email: 'a@email.com', password: '123')
    @user3 = User.create!(email: 'b@email.com', password: '1234')
    @user4 = User.create!(email: 'c@email.com', password: '456')
    movie = Movie.create!(api_id: 550)
    movie2 = Movie.create!(api_id: 551)
    movie3 = Movie.create!(api_id: 552)
    UserMovie.create!({user_id: @user.id, movie_id: movie.id})
    UserMovie.create!({user_id: @user.id, movie_id: movie2.id})
    UserMovie.create!({user_id: @user.id, movie_id: movie3.id})
    UserMovie.create!({user_id: @user2.id, movie_id: movie.id})
    UserMovie.create!({user_id: @user2.id, movie_id: movie2.id})
    UserMovie.create!({user_id: @user2.id, movie_id: movie3.id})
    UserMovie.create!({user_id: @user3.id, movie_id: movie2.id})
    UserMovie.create!({user_id: @user3.id, movie_id: movie3.id})

binding.pry
  end
  describe "relationships" do
    it { should belong_to :user }
    it { should belong_to :movie }
  end

  describe "class methods" do
    describe "::sort_user_movies_by_title(user_id)" do
      it "returns a list of user movies alphabetically" do

      end
    end
    describe "::search_user_movies_by_genre(genre, search_query)" do
      it "returns a list of user movies alphabetically" do

      end
    end
    describe "::user_movies_by_rating(user_id)" do
      it "returns a list of user movies sorted by highest rated" do

      end
    end
    describe "::user_movies_by_trending(user_id)" do
      it "returns a list of user movies sorted by highest rated" do

      end
    end
    describe "::user_movies_by_top_forty(user_id)" do
      it "returns a list of user movies sorted by highest rated" do

      end
    end
  end
end
