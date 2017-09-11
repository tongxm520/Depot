class Reviewer < ActiveRecord::Base
  self.table_name="Reviewer"
  self.primary_key = "rID"
  has_many :ratings,foreign_key: "rID"
  has_many :movies,through: :ratings

  #Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.
  #SELECT name FROM `Reviewer` INNER JOIN `Rating` ON `Rating`.`rID` = `Reviewer`.`rID` WHERE (Rating.ratingDate is NULL)
  def self.get_reviewers_without_date
    self.joins(:ratings).where("Rating.ratingDate is NULL").select("name")
  end

  #For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. 
  def self.get_movie_by_reviewer
    query=sanitize_sql("SELECT R.name,M.title FROM Movie M,Reviewer R,Rating r1,Rating r2 WHERE M.mID=r1.mID AND R.rID=r1.rID AND M.mID=r2.mID AND R.rID=r2.rID AND r1.rID=r2.rID AND r1.mID=r2.mID AND r1.stars> r2.stars AND r1.ratingDate>r2.ratingDate")
    self.connection.execute(query)
  end
end
