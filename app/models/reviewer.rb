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
    self.find_by_sql(query)
  end

  #TODO: For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order. 
  def self.pairs_of_reviewers
  end

  #Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.) 
  def self.more_than_three
    self.joins(:ratings).group("Rating.rID").having("COUNT(stars)>2")
  end
end
