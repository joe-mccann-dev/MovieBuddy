# README
A Sinatra app that accesses the OMDb API and returns a list of movies. I made this app in Rails, but I think its simple nature warrants giving the Sinatra approach a try.

my original Rails app: https://github.com/joe-mccann-dev/movie-finder

## Local Installation

1. clone repo
2. `bundle install`
3. Get your free API key at https://www.omdbapi.com/
6. setup local environment variable: `echo "export OMDB_API_KEY=12345678 >> ~/.bashrc`
7. start up rack: `rackup -p 4567`
8. Search for some movies.

### About API Requests

The way this particular API is structured required me to first make an "initial request" to get all of the ids returned by a title search, and then using `map`, iterate over each id to cache requests and make requests in parallel. Querying this API with the movie's id grants more information, such as "Actors" and "Plot". I used the `Typhoeus` gem to make requests in parallel, see: https://github.com/typhoeus/typhoeus. As the maintainer's state, "Typhoeus wraps libcurl in order to make fast and reliable requests." This seemed like a good fit for making several requests in parallel with the added benefit of caching requests. Following their basic example was enough to accomplish this.

### Further thoughts

It would be nice if this API offered an "Actor" parameter, so that we could find all movies an given actor starred in.