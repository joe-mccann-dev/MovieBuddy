require 'json'
require 'typhoeus'
require './movie_search_cache.rb'

class MovieFinder
  attr_reader :title, :release_year, :imdb_ids, :movies, :api_limit_reached
  
  def initialize(title, release_year = nil)
    @title = title.downcase
    @release_year = release_year
    @imdb_ids = imdb_ids
    @movies = find_movies
    @api_limit_reached = initial_response["Error"] == "Request limit reached!"
  end

  private

  def find_movies
    return unless imdb_ids

    # improve performance by caching requests and making requests in parallel
    hydra = Typhoeus::Hydra.new
    requests = parallel_requests(hydra)
    hydra.run
    requests.map do |request|
      response = JSON.parse(request.response.body) if request.response.code == 200 
      response["imdb_page"] = imdb_page(response["imdbID"])
      response
    end
  end

  def imdb_ids
    body = initial_response      
    initial_results = body["Search"]
    return unless initial_results

    initial_results.map { |result| result["imdbID"] }
  end

  def initial_response
    JSON.parse(initial_request.body)
  end

  # first response returns list of movie objects with imdbID keys
  # imdb id only accessible by first doing a generic search
  # once relevant ids are available, we can get more complete details by requesting with the id parameter
  def initial_request
    Typhoeus.get("https://www.omdbapi.com/?apikey=#{ENV["OMDB_API_KEY"]}&s=#{title}&type=movie&y=#{release_year}")
  end

  def parallel_requests(hydra)
    imdb_ids.map do |id|
      request = Typhoeus::Request.new("https://www.omdbapi.com/?apikey=#{ENV["OMDB_API_KEY"]}&i=#{id}")
      hydra.queue(request)
      request
    end
  end

  def imdb_page(id)
    "https://www.imdb.com/title/#{id}"
  end
end
