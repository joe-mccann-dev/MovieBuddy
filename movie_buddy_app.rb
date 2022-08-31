require 'sinatra'
require './movie_finder'

get '/' do
  @finder = MovieFinder.new('Casablanca')
  erb :layout do
    erb :index
  end
end
  