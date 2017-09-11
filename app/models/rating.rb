class Rating < ActiveRecord::Base
  self.table_name="Rating"
  belongs_to :movie,foreign_key: "mID"
  belongs_to :reviewer,foreign_key: "rID"

  #Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.
  def self.get_rating
    self.joins(:movie).
    joins(:reviewer).
    select("Reviewer.name,Movie.title,Rating.stars,Rating.ratingDate").
    order("Reviewer.name,Movie.title,Rating.stars")
  end
end
