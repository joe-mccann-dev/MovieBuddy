require 'sinatra'
require './movie_finder'

get '/' do
  if params[:title]
    @finder = MovieFinder.new(params[:title], params[:release_year])
    @results = @finder.movies
  end

  erb :layout do
    erb :index
  end
end
  