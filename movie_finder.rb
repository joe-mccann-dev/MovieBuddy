require 'json'
require 'typhoeus'

class MovieFinder
  attr_reader :title

  def initialize(title, release_year = nil)
    @title = title.downcase.strip
    @release_year = release_year
  end
end
