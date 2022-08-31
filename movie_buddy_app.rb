require 'sinatra'
require './movie_finder'

get '/' do
  @finder = MovieFinder.new(params[:title], params[:release_year]) if params[:title]
 
  erb :layout do
    erb :index
  end
end
  