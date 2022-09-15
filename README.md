# README
A Sinatra app that accesses the OMDb API and returns a list of movies. This was my first time using Sinatra. It seemed like the appropriate choice for an application like this.

![Alt text](/public/images/movie-buddy-screenshot.png "Searching for 'Lord of The Rings' movies by title")

## Local Installation

1. clone repo
2. `bundle install`
3. Get your free API key at https://www.omdbapi.com/
6. setup local environment variable: `echo "export OMDB_API_KEY=12345678" >> ~/.bashrc`
7. start up rack: `rackup -p 4567`
8. Search for some movies.

### Code Structure and API Requests

The root route is contained within `movie_buddy_app.rb` file which is required and run in the `config.ru` file.  When the root route is hit, a `MovieFinder` object is initialized ( `@finder` ) if the title parameter is present. Then, the app sends two or more requests to the OMDb API, an initial request to get the movie ids of all movies returned by the title search. Then, another request for each id returned by the initial request. See: [MovieFinder#imdb_ids](https://github.com/joe-mccann-dev/MovieBuddy/blob/8fb7bc229599bd01cc8419f260a598d732a478bf/movie_finder.rb#L36) for more details.

 Querying this API with the returned ids grants more information, such as "Actors" and "Plot". I used the `Typhoeus` gem to make requests in parallel, see: https://github.com/typhoeus/typhoeus. 
 
 As the maintainer's state, "Typhoeus wraps libcurl in order to make fast and reliable requests." This seemed like a good fit for making several requests in parallel with the added benefit of caching requests. See [movie_search_cache.rb](https://github.com/joe-mccann-dev/MovieBuddy/blob/8fb7bc229599bd01cc8419f260a598d732a478bf/movie_search_cache.rb#L1contains) and [caching with Typhoeus](https://github.com/typhoeus/typhoeus#caching) for more details regarding caching.

### Further thoughts

It would be nice if this API offered an "Actor" parameter, so that we could find all movies an given actor starred in.