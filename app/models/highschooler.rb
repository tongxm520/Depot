class Highschooler < ActiveRecord::Base
  self.table_name="Highschooler"
  self.primary_key = "ID"

  has_many :friends,through: :friendship,source: :user
  has_many :friendship,foreign_key: "ID2",class_name: "Friend"

  has_many :followers,through: :follower_follows,source: :follower
  has_many :follower_follows,foreign_key: "ID2",class_name: "Likes"

  has_many :followees,through: :followee_follows,source: :followee
  has_many :followee_follows,foreign_key: "ID1",class_name: "Likes"

  #Find the names of all students who are friends with someone named Gabriel. 
  #Highschooler.whose_friends('Gabriel')
  #Highschooler.whose_friends('Jessica')
  def self.whose_friends(name)
    query=sanitize_sql(["SELECT Highschooler.name AS friend,Friend.ID2 AS user_id,u.name AS user FROM Highschooler INNER JOIN Friend ON Highschooler.ID = Friend.ID1 INNER JOIN Highschooler AS u ON u.name=? WHERE Friend.ID2 = u.ID",name])
    self.find_by_sql(query)
  end

  #For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like. 
  def self.younger_followees
    query="SELECT Highschooler.name,Highschooler.grade,u.name AS followee_name,u.grade  AS followee_grade FROM Highschooler INNER JOIN Likes ON Highschooler.ID = Likes.ID1 INNER JOIN Highschooler AS u ON Highschooler.grade-u.grade>1 WHERE Likes.ID2 = u.ID"
    self.find_by_sql(query)
  end

  #For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order. 
  def self.like_each_other
    query="SELECT t1.name from (
		(SELECT DISTINCT ta.name FROM (SELECT Highschooler.name FROM Highschooler INNER JOIN Likes ON Highschooler.ID = Likes.ID1 WHERE Likes.ID2 IN (SELECT Highschooler.ID FROM Highschooler INNER JOIN Likes ON Highschooler.ID = Likes.ID1)) AS ta)
		UNION ALL 
		(SELECT DISTINCT tb.name FROM (SELECT Highschooler.name FROM Highschooler INNER JOIN Likes ON Highschooler.ID = Likes.ID2 WHERE Likes.ID1 IN (SELECT Highschooler.ID FROM Highschooler INNER JOIN Likes ON Highschooler.ID = Likes.ID2)) AS tb)
	) AS t1 GROUP BY t1.name HAVING count(*) >= 2 ORDER BY t1.name"
    self.find_by_sql(query)
  end

  #Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade.
  def self.non_likes
    query="SELECT t1.grade,t1.name from ((SELECT Highschooler.grade,Highschooler.name FROM Highschooler LEFT JOIN Likes ON Highschooler.ID = Likes.ID1 WHERE Likes.ID1 IS NULL)
    UNION ALL
    (SELECT Highschooler.grade,Highschooler.name FROM Highschooler LEFT JOIN Likes ON Highschooler.ID = Likes.ID2 WHERE Likes.ID2 IS NULL)) AS t1
    GROUP BY t1.grade,t1.name HAVING count(*) >= 2 ORDER BY t1.grade,t1.name"
    self.find_by_sql(query)
  end

  #For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. 
  def self.final_point
    query="SELECT Highschooler.name AS A_name,Highschooler.grade AS A_grade,u.name AS B_name,u.grade AS B_grade FROM Highschooler INNER JOIN Likes ON Highschooler.ID = Likes.ID1 INNER JOIN Highschooler AS u ON u.ID NOT IN (SELECT DISTINCT Likes.ID1 FROM Likes) WHERE Likes.ID2 = u.ID"
    self.find_by_sql(query)
  end

  #Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade. 
  def self.same_grade_friends
    query="SELECT DISTINCT name,grade 
           FROM Highschooler INNER JOIN Friend 
           ON Friend.ID1=Highschooler.ID
           WHERE Highschooler.ID NOT IN 
           (SELECT DISTINCT u1.ID FROM Highschooler AS u1,Friend,Highschooler AS u2 WHERE u1.ID=Friend.ID1 AND u2.ID=Friend.ID2 AND u1.grade<>u2.grade) 
           GROUP BY grade,name"
    self.find_by_sql(query)
  end

  #For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C. 
  def self.recommend_friends
    query="SELECT DISTINCT a.name AS A_name,a.grade AS A_grade,b.name AS B_name,b.grade AS B_grade,c.name AS C_name,c.grade AS C_grade FROM Highschooler AS a,Likes,Friend AS f1,Friend AS f2,Highschooler AS b,Highschooler AS c WHERE NOT EXISTS (SELECT * FROM Friend WHERE ID1=a.ID AND ID2=b.ID OR ID1=b.ID AND ID2=a.ID) AND a.ID = Likes.ID1 AND Likes.ID2 = b.ID AND a.ID=f1.ID1 AND c.ID=f1.ID2 AND b.ID=f2.ID1 AND c.ID=f2.ID2"
    self.find_by_sql(query)
  end
  
  #Find the difference between the number of students in the school and the number of different first names. 
  def self.duplicated_names_count
    query="SELECT (SELECT COUNT(*) FROM Highschooler)-(SELECT COUNT(*) FROM Highschooler WHERE ID NOT IN (SELECT DISTINCT a.ID FROM Highschooler a,Highschooler b WHERE a.ID<>b.ID AND a.name=b.name)) AS difference"
    self.find_by_sql(query)
  end

  #Find the name and grade of all students who are liked by more than one other student. 
  def self.more_than_one
    query="SELECT DISTINCT name,grade FROM Highschooler INNER JOIN Likes ON Likes.ID2 = Highschooler.ID WHERE (SELECT COUNT(*) FROM Likes WHERE ID2=Highschooler.ID) > 1"
    self.find_by_sql(query)
  end
end

=begin
https://stackoverflow.com/questions/2621382/alternative-to-intersect-in-mysql

Alternative to Intersect in MySQL

There is a more effective way of generating an intersect, by using UNION ALL and GROUP BY. Performances are twice better according to my tests on large datasets.

Example:

SELECT t1.value from (
  (SELECT DISTINCT value FROM table_a)
  UNION ALL 
  (SELECT DISTINCT value FROM table_b)
) AS t1 GROUP BY t1.value HAVING count(*) >= 2;

It is more effective, because with the INNER JOIN solution, MySQL will look up for the results of the first query, then for each row, look up for the result in the second query. With the UNION ALL-GROUP BY solution, it will query results of the first query, results of the second query, then group the results all together at once.


CREATE TABLE `table_a` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `value` varchar(255),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE `table_b` LIKE `table_a`;
=end
