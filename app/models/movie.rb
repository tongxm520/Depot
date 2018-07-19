class Movie < ActiveRecord::Base
  self.table_name="Movie"
  self.primary_key = "mID"
  has_many :ratings,foreign_key: "mID"
  has_many :reviewers,through: :ratings

  #Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. 
  #SELECT title,year FROM `Movie` INNER JOIN `Rating` ON `Rating`.`mID` = `Movie`.`mID` WHERE (Rating.stars > 3) ORDER BY year
  def self.get_years
    self.joins(:ratings).where("Rating.stars > ?",3).select("title,year").order("year")
  end

  #Find the titles of all movies that have no ratings. 
  #Movie.get_movies_without_rating.entries
  def self.get_movies_without_rating
    query=sanitize_sql("SELECT title FROM Movie WHERE mID NOT IN (SELECT Rating.mID FROM Movie,Rating WHERE Rating.mID=Movie.mID)")
    self.connection.execute(query)
  end 

  #For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title. 
  #Movie.get_movie_by_stars.entries
  def self.get_movie_by_stars
    query=sanitize_sql("SELECT M.title,COUNT(R.stars) FROM Movie M,Rating R WHERE R.mID=M.mID GROUP BY R.mID HAVING COUNT(R.stars) > ANY (SELECT COUNT(R.stars) FROM Movie M,Rating R WHERE R.mID=M.mID GROUP BY R.mID) ORDER BY M.title DESC")
    self.connection.execute(query)
  end

  #For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title. 
  def self.get_rating_spread
    self.joins(:ratings).
    group("Rating.mID").
    select("Movie.title,(MAX(Rating.stars)-MIN(Rating.stars)) AS spread").
    order("spread DESC,Movie.title")
  end

  #Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.) 
  #mysql reserved words: before,after
  def self.get_difference
    query=sanitize_sql(["SELECT ABS(beforeYear.avgRating-afterYear.avgRating) AS difference FROM (SELECT AVG(x.avgBefore) AS avgRating FROM (SELECT AVG(R.stars) AS avgBefore FROM Rating R,Movie M WHERE R.mID=M.mID AND M.year<? GROUP BY R.mID) AS x) AS beforeYear, (SELECT AVG(x.avgAfter) AS avgRating FROM (SELECT AVG(R.stars) AS avgAfter FROM Rating R,Movie M WHERE R.mID=M.mID AND M.year>? GROUP BY R.mID) AS x) AS afterYear",'1980','1980'])
    self.connection.execute(query)
    #rails mysql aggregation bigdecimal precision loss
    #Movie.get_difference.entries[0][0].to_s
  end

  #Find the titles of all movies not reviewed by Chris Jackson. 
  #SELECT title FROM Movie WHERE mID NOT IN(SELECT Rating.mID FROM `Rating` INNER JOIN `Reviewer` ON `Reviewer`.`rID` = `Rating`.`rID` WHERE (Reviewer.name='Chris Jackson'))
  #Movie.not_reviewed_by
  def self.not_reviewed_by
    subquery=Rating.joins(:reviewer).where("Reviewer.name=?","Chris Jackson").select("Rating.mID").to_sql
    query=sanitize_sql("SELECT title FROM Movie WHERE mID NOT IN(#{subquery})")
    self.find_by_sql(query)
  end

  #List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order. 
  def self.average_ratings
    self.joins(:ratings).group("Rating.mID").
    select("title,(SELECT  AVG(stars)
            FROM  Rating
            WHERE  mID = Movie.mID
          ) AS avg_stars,MIN(stars) AS min_stars,MAX(stars) AS max_stars").
    order("avg_stars,title")
  end

  #Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.) 
  def self.more_than_one
    query="SELECT m1.title,m1.director FROM Movie m1,Movie m2 WHERE m1.director=m2.director AND m1.mID<>m2.mID ORDER BY m1.director,m1.title"
    self.find_by_sql(sanitize_sql(query))
  end

  #Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) 
  def self.highest_average_rating
    query="SELECT Movie.title,AVG(stars) AS avgstars FROM Rating,Movie 
    WHERE Movie.mID=Rating.mID 
    GROUP BY Rating.mID
    HAVING avgstars= (SELECT MAX(r.avg_stars) AS highest_avg_stars 
    FROM (SELECT mID, AVG(stars) AS avg_stars
    FROM Rating GROUP BY mID) AS r)"
    self.find_by_sql(query)
  end

  def self.highest_average_rating_by_sort
    self.joins(:ratings).group("Rating.mID").
    select("title,(SELECT  AVG(stars)
            FROM  Rating
            WHERE  mID = Movie.mID
          ) AS avg_stars").
    order("avg_stars desc,title").limit(1)
  end

  #TODO:For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL. 
  def self.highest_rating_movies
  end
end

=begin

You can't use avg that way. In my personal movie database,
select * from movie having year > avg(year);
produces nothing, and
select * from movie having year > (select avg (year) from movie);
produces the expected result.

SELECT v.*
  FROM (
         SELECT 1 AS foo
       ) v;

两个数的差值
the difference between the two numbers
[数]差额,差值, 差分


SELECT x.user, 
       AVG(x.cnt)
    FROM (SELECT user, COUNT(answer) AS cnt
          FROM surveyValues 
          WHERE study='a1' 
          GROUP BY user) x
GROUP BY x.user

select CS.avgGPA - NonCS.avgGPA
from (select avg(GPA) as avgGPA from students
      where id in (
         select student_id from applies where major = 'CS')) as CS,
     (select avg(GPA) as avgGPA from students
      where id not in (
         select student_id from applies where major = 'CS')) as NonCS;

mysql> SELECT
    ->     d.subcategory_id,
    ->     d.vendor_id,
    ->     MIN(d.price) AS price,
    ->     d.inserted_at
    -> FROM product AS d
    -> JOIN (SELECT
    ->         b.category_id,
    ->         b.subcategory_id,
    ->         b.vendor_id,
    ->         a.last_iat
    ->     FROM product AS b 
    ->     JOIN (SELECT
    ->             a.category_id,
    ->             a.subcategory_id,
    ->             a.vendor_id,
    ->             a.price,
    ->             MAX(a.inserted_at) AS last_iat
    ->         FROM product AS a
    ->         GROUP BY a.category_id,a.subcategory_id,a.vendor_id
    ->         ) AS a
    ->         ON (a.category_id=b.category_id AND a.subcategory_id=b.subcategory_id AND a.vendor_id=b.vendor_id)
    ->     GROUP BY b.category_id,b.subcategory_id,b.vendor_id) AS c
    ->     ON (c.category_id=d.category_id AND c.subcategory_id=d.subcategory_id AND c.last_iat=d.inserted_at)
    -> WHERE d.category_id=1
    -> GROUP BY d.category_id,d.subcategory_id;
+----------------+-----------+-------+---------------------+
| subcategory_id | vendor_id | price | inserted_at         |
+----------------+-----------+-------+---------------------+
|              1 |         2 |  9.00 | 2015-07-26 08:00:00 |
|              2 |         3 | 16.00 | 2015-07-23 04:00:00 |
+----------------+-----------+-------+---------------------+
2 rows in set (0.00 sec)


You can make this easier if you generate the subquery separately and use a join instead of a correlated subquery:

subquery = Schedule.select('MIN(price) as min_price, object_id').group(:object_id).to_sql
Object.joins("JOIN (#{subquery}) schedules ON objects.p_id = schedules.object_id").
select('objects.*, schedules.min_price).limit(5)

=end



