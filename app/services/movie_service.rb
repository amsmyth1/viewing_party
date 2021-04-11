require 'ostruct'

class MovieService
  def self.top_movies(limit)
    results = []
    number_pages = (limit / 20) + 1
    number_pages.times do |n|
      movie_data = get_data(url_storage(num: n)[:movie_top])
      movie_data[:results].each do |movie_info|
        results << MovieFacade.create_movie_openstruct(movie_info)
      end
    end
    results.first(limit)
  end

  def self.movie_search(search, limit)
    search_results = []
    unless results_page_count((url_storage(num: 0, query: search)[:movie_search])).nil?
      results_page_count((url_storage(num: 0, query: search)[:movie_search])).times do |n|
        search_data = get_data((url_storage(num: n, query: search)[:movie_search]))
        search_data[:results].each do |movie_info|
          search_results << MovieFacade.create_movie_openstruct(movie_info)
        end
      end
    end
    search_results.first(limit)
  end

  def self.movie_information(api_movie_id)
    info = get_data((url_storage(movie_id: api_movie_id)[:movie_info]))
    unless info[:id].nil?
      MovieFacade.create_movie_details_openstruct(info)
    else
      []
    end
  end

  def self.trending_movies(limit)
    results = []
    until results.length >= limit
      trending_movies_data = get_data(url_storage[:trending_movies])
      trending_movies_data[:results].each do |movie_info|
        results << MovieFacade.create_movie_openstruct(movie_info)
      end
    end
    results.first(limit)
  end

  # def self.create_movie_openstruct(movie_info)
  #   OpenStruct.new({  api_id: movie_info[:id],
  #                     title: movie_info[:title],
  #                     vote_average: movie_info[:vote_average] })
  # end
  #
  # def self.create_movie_details_openstruct(movie_info)
  #   OpenStruct.new({ api_id: movie_info[:id],
  #                    title: movie_info[:title],
  #                    vote_average: movie_info[:vote_average],
  #                    runtime: movie_info[:runtime],
  #                    genres: movie_info_genres(movie_info[:genres]),
  #                    summary: movie_info[:overview],
  #                    cast: movie_info_cast(movie_info[:id]),
  #                    reviews: movie_info_reviews(movie_info[:id]),
  #                    poster_path: movie_info[:poster_path] })
  # end
  def self.get_data(url)
    response = Faraday.get(url)
    data = response.body
    JSON.parse(data, symbolize_names: true)
  end


  def self.movie_info_genres(genres)
    unless genres.nil?
      genres.map do |genre|
        genre[:name]
      end
    end
  end

  def self.movie_info_cast(api_movie_id)
    cast_info = get_data((url_storage(movie_id: api_movie_id)[:movie_cast]))
    movie_cast = {}
    cast_info[:cast].each_with_index do |cast_member, index|
      movie_cast[(cast_member[:name])] = cast_member[:character] if index < 10
    end
    movie_cast
  end

  def self.movie_info_reviews(api_movie_id)
    review_info = get_data((url_storage(movie_id: api_movie_id)[:movie_reviews]))
    movie_reviews_info = { total_reviews: review_info[:total_results] }
    results_page_count((url_storage(movie_id: api_movie_id)[:movie_reviews])).times do |n|
      review_info = get_data((url_storage(movie_id: api_movie_id, num: n)[:movie_reviews]))
      review_info[:results].each do |review|
        movie_reviews_info[(review[:author_details][:username])] = review[:content]
      end
    end
    movie_reviews_info
  end

  def self.results_page_count(url)
    get_data(url)[:total_pages]
  end

  def self.url_storage(movie_id: 1, num: 0, query: '', api_key: ENV['API_KEY'])
    uri = 'https://api.themoviedb.org/3/'
    url_storage = {}
    url_storage[:movie_top] = "#{uri}discover/movie?api_key=#{api_key}&language=en-US&sort_by=vote_average.desc&include_adult=false&include_video=false&page=#{num + 1}&vote_count.gte=100&with_original_language=en"
    url_storage[:movie_info] = "#{uri}movie/#{movie_id}?api_key=#{api_key}&language=en-US"
    url_storage[:movie_reviews] = "#{uri}movie/#{movie_id}/reviews?api_key=#{api_key}&language=en-US&page=#{num + 1}"
    url_storage[:movie_cast] = "#{uri}movie/#{movie_id}/credits?api_key=#{api_key}&language=en-US"
    url_storage[:movie_search] = "#{uri}search/movie?api_key=#{api_key}&language=en-US&query=#{query}&page=#{num + 1}&include_adult=false"
    url_storage[:poster_path] = "#{uri}movie/#{movie_id}?api_key=#{api_key}&language=en-US"
    url_storage[:trending_movies] = "#{uri}trending/movie/day?api_key=#{api_key}&language=en-US"
    url_storage
  end
end
