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
    query=sanitize_sql("SELECT ABS(beforeYear.avgRating-afterYear.avgRating) AS difference FROM (SELECT AVG(x.avgBefore) AS avgRating FROM (SELECT AVG(R.stars) AS avgBefore FROM Rating R,Movie M WHERE R.mID=M.mID AND M.year<'1980' GROUP BY R.mID) AS x) AS beforeYear, (SELECT AVG(x.avgAfter) AS avgRating FROM (SELECT AVG(R.stars) AS avgAfter FROM Rating R,Movie M WHERE R.mID=M.mID AND M.year>'1980' GROUP BY R.mID) AS x) AS afterYear")
    self.connection.execute(query)
    #rails mysql aggregation bigdecimal precision loss
    #Movie.get_difference.entries[0][0].to_s
  end
end

=begin
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


=end



