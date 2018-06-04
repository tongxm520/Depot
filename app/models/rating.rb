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

  #Find the names of all reviewers who rated Gone with the Wind. 
  #SELECT Reviewer.name FROM `Rating` INNER JOIN `Movie` ON `Movie`.`mID` = `Rating`.`mID` INNER JOIN `Reviewer` ON `Reviewer`.`rID` = `Rating`.`rID` WHERE (Movie.title='Gone with the Wind')
  def self.who_rate
    self.joins(:movie).joins(:reviewer).where("Movie.title=?","Gone with the Wind").select("Reviewer.name")
  end

  #For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. 
  #SELECT Reviewer.name,Movie.title,Rating.stars FROM `Rating` INNER JOIN `Movie` ON `Movie`.`mID` = `Rating`.`mID` INNER JOIN `Reviewer` ON `Reviewer`.`rID` = `Rating`.`rID` WHERE (Reviewer.name=Movie.director)
  def self.same_as_director
    self.joins(:movie).joins(:reviewer).where("Reviewer.name=Movie.director").select("Reviewer.name,Movie.title,Rating.stars")
  end

  #For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars. 
  def self.lowest_stars
    self.joins(:movie).joins(:reviewer).where("stars= (SELECT MIN(stars) FROM Rating)").select("Reviewer.name,Movie.title,Rating.stars")
  end
end
