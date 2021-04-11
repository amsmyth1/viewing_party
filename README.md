# Viewing Party
*Virtual Viewing, made easy. Add friends, create parties, invite your friends to the parties!*

## About this Project
Viewing Party is a User web application for creating and tracking movie viewing parties. Users can register for an account with an email and password. This application interacts with the [MovieDataBase](https://www.themoviedb.org/?language=en-US) API so movie information is always up to date. Add friends to your profile via email. Find the top rated movies or search for your favorite movie by title, if you want to watch it - you can! Once the perfect movie is selected you can create a viewing party and selectively invite your friends!

## Summary

  - [Getting Started](#getting-started)
  - [Runing the tests](#running-the-tests)
  - [Database Schema](#database-schema)
  - [Deployment](#deployment)
  - [Application Code](#application-code)
    - [API Implementation](#api-implementation)
  - [Built With](#built-with)
  - [Contributing](#contributing)
  - [Versioning](#versioning)
  - [Authors](#authors)
  - [License](#license)
  - [Acknowledgments](#acknowledgments)

## Getting Started

To get the web application running, please fork and clone down the repo.
`git clone <your@github.account/viewing_party>`

### Prerequisites

To run this application you will need Ruby 2.5.3 and Rails 5.2.4.3, Travis CI, OpenStruct

### Installing

- Install the gems  
`bundle install`

- Create the database  
`rails db{:drop, :create, :migrate}`

- Create local environmental variables  
  If `config/application.yaml` does not exist, install Figaro from the command line  
  `bundle exec figaro install`  
  This command will create the file and add it to .gitignore

- Add your API key and the below variables
  ```yaml
  #config/application.yaml
  API_KEY: <your_tmdb_api_key_here>
  API_TEST_COUNT_URL: "https://api.themoviedb.org/3/discover/movie?api_key=<YOUR_TMBD_API_KEY_HERE>&language=en-US&sort_by=vote_average.desc&include_adult=false&include_video=false&page=1"
  SEARCH_RESULT_COUNT: "40"
  ```
  Please visit The MovieDataBase to get an API key. The SEARCH_RESULT_COUNT variable is to specify how many search results to return when a movie is searched by title. To allow for dynamic code and changes to be made without having to change application code.

## Running the tests
RSpec testing suite is utilized for testing this application. Please note webmock, figaro, and VCR are utilized.
- Run the RSpec suit to ensure everything is passing as expected  
`bundle exec rspec`

## Database Schema
The schema represents the relationships between the models in the database.
  - A User can have many friends and parties.
  - A Party can have 1 host and many invitees.
  - A Party can have 1 movie and 1 host and many invitees.

![](viewing-party-schema.png)

#### Debugging tests
Please note, you may need to delete `spec/fixtures/vcr_cassettees` to get tests working.

## Deployment

Travis CI was utilized for deployment on this project. Please note this project was developed during the licensing issues with `mimemagic` that persisted on the week of March 29, 2021. Adjustments were made, but as the licensing issues develops changes to gems might need to be implements.

To deploy this application please utilize your own hosting service. The original repo is deployed to Heroku-18.

## Application code
This application code utilizes MVC principles along with the Facade Design Pattern.

### API Implementation
Facade patterns were used to implement the API endpoints. Below, follow the code path of the Movies Details Page.

- The `MoviesController` controls the Movie Details Page and the Discover Movies Page.
```ruby
  # app/controllers/movies_controller.rb
  class MoviesController < ApplicationController
    ...

    def show
      @movie_info = MovieFacade.movie_information(params[:id])
      @movie = MovieFacade.create_movie(params[:id])
      cookies[:bdseivom_di] = @movie_info.api_id
    end
  end
```
- The `MovieFacade` interacts with the service objects and the models so the Controller remains more manageable.
```ruby
# app/facades/movie_facade.rb
class MovieFacade
    ...

    def self.movie_information(api_movie_id)
      MovieService.movie_information(api_movie_id)
    end

    def self.create_movie(api_id)
      if Movie.exists?(api_id)
        movie = Movie.find_by(api_id)
      else
        movie = Movie.create({api_id: api_id})
      end
      movie
    end
  end
```
- The `MovieService` object interacts with the API datapoint and creates OpenStruct objects to interact with various facades for different components of our application code. In this example, most of the content on the Movie Details page is generated from an OpenStruct object.
```ruby
  # app/services/movie_service.rb
  require 'ostruct'

  class MovieService
    ...

    def self.movie_information(api_movie_id)
      info = get_data((url_storage(movie_id: api_movie_id)[:movie_info]))
      if info[:id] != nil
        OpenStruct.new({
          api_id: info[:id],
          title: info[:title],
          vote_average: info[:vote_average],
          runtime: info[:runtime],
          genres: movie_info_genres(info[:genres]),
          summary: info[:overview],
          cast: movie_info_cast(api_movie_id),
          reviews: movie_info_reviews(api_movie_id)
        })
      else
        []
      end
    end
  end
```

## Authors

- **Joseph Budina**| [GitHub](https://github.com/josephbudina) |
    [LinkedIn](https://www.linkedin.com/in/joseph-budina-7a0bb4202/)
- **Katy La Tour**
     | [GitHub](https://github.com/klatour324) |
    [LinkedIn](https://www.linkedin.com/in/klatour324/)
- **Alexa Morales Smyth**
     | [GitHub](https://github.com/amsmyth1) |
    [LinkedIn](https://linkedin.com/alexamorales)
