require 'sinatra'
require './movie_finder'

get '/' do
  @finder = MovieFinder.new(params[:title], params[:release_year]) if params[:title]

  erb :layout, layout: false do
    erb :index
  end
end

helpers do
  def results(finder)    
    return unless finder

    return api_limit_reached_message if finder.api_limit_reached

    @movies = finder.movies
    return no_results_message unless @movies
    
    erb :results, collection: @movies
  end

  def api_limit_reached_message
    '<p class="error">The api_key for this app has reached
    its daily limit of allotted requests.
    Try again tomorrow.</p>'
  end

  def no_results_message
    '<p class="error">No results found.</p>'
  end
end
