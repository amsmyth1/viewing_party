require 'rails_helper'

RSpec.describe "As a user after I click the link from my dashboard to visit the Discover page" do
  describe "takes me to the landing page" do
    it "should display a search form to search by movie title (returning 40 results)" do
      user = User.create(email: "joeb@email.com", password: "test")
      visit root_path
      click_link "Login"
      fill_in :email, with: user.email.upcase
      fill_in :password, with: user.password
      click_button 'Login'
      within(".topnav") do
        click_link "Discover Movies"
      end

      expect(current_path).to eq(discover_path)
      expect(page).to have_content("Hello, #{user.email}!")
      expect(page).to have_button("Find Top Rated Movies")
      expect(page).to have_button("Find Movies")
    end
  end

  describe "search for top 40 rated movies" do
    it "should return the top 40 movie titles based on Vote Average" do
      VCR.use_cassette('top_forty_movies') do
        user = User.create(email: "joeb@email.com", password: "test")
        visit root_path
        click_link "Login"
        fill_in :email, with: user.email.upcase
        fill_in :password, with: user.password
        click_button 'Login'
        within(".topnav") do
          click_link "Discover Movies"
        end
        click_button("Find Top Rated Movies")

        expect(page).to have_content("Gabriel's Inferno Part II")
      end
    end
  end

  describe "search for a movie by title" do
    it "should return movies that match the user query and thier rating" do
      VCR.use_cassette('movie_search') do
        user = User.create(email: "joeb@email.com", password: "test")
        visit root_path
        click_link "Login"
        fill_in :email, with: user.email.upcase
        fill_in :password, with: user.password
        click_button 'Login'
        within(".topnav") do
          click_link "Discover Movies"
        end
        fill_in :movie_query, with: "phoenix"
        click_on("Find Movies")

        expect(page).to have_content("Dark Phoenix")
        expect(page).to have_content("Vote Average: 6.1")
        expect(page).to have_content("Harry Potter and the Order of the Phoenix")
        expect(page).to have_content("Rising Phoenix")
        expect(page).to have_content("Griffin & Phoenix")
        expect(page).to have_content("Phoenix Forgotten")
      end
    end
    describe "create a movie model when a link is clicked" do
      it "text" do
        VCR.use_cassette('movie_search_model_save') do
          user = User.create(email: "joeb@email.com", password: "test")
          visit root_path
          click_link "Login"
          fill_in :email, with: user.email.upcase
          fill_in :password, with: user.password
          click_button 'Login'
          within(".topnav") do
            click_link "Discover Movies"
          end
          fill_in :movie_query, with: "phoenix"
          click_on("Find Movies")

          click_on("Dark Phoenix") #api_id = 320288
          # expect(Movie.exists?(api_id: 320288)).to eq(true)

          visit discover_path
          fill_in :movie_query, with: "phoenix"
          click_on("Find Movies")

          click_on("Dark Phoenix") #api_id = 320288
          # movie = Movie.find_by(api_id: 320288)
        end
      end
    end
  end
end
