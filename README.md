# 相关介绍:大杂烩
- app/controllers/api/v1 => API实践,token身份认证,Pundit
- 学生申请学校: app/models下student.rb apply.rb college.rb
- movie-rating: app/models下movie.rb rating.rb reviewer.rb 多表关联查询
- social network: app/models下highschooler.rb friend.rb likes.rb 复杂的sql查询
- rspec

# Friends Recommendation
## app/models/highschooler.rb
### For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C.

    def self.recommend_friends
      query="SELECT DISTINCT a.name AS A_name,a.grade AS A_grade,b.name AS B_name,b.grade AS B_grade,c.name AS C_name,c.grade AS C_grade FROM Highschooler AS a,Likes,Friend AS f1,Friend AS f2,Highschooler AS b,Highschooler AS c WHERE NOT EXISTS (SELECT * FROM Friend WHERE ID1=a.ID AND ID2=b.ID OR ID1=b.ID AND ID2=a.ID) AND a.ID = Likes.ID1 AND Likes.ID2 = b.ID AND a.ID=f1.ID1 AND c.ID=f1.ID2 AND b.ID=f2.ID1 AND c.ID=f2.ID2"
      self.find_by_sql(query)
    end
    
    +--------+---------+-----------+---------+---------+---------+
    | A_name | A_grade | B_name    | B_grade | C_name  | C_grade |
    +--------+---------+-----------+---------+---------+---------+
    | Andrew | 10      | Cassandra | 9       | Gabriel | 9       |
    | Austin | 11      | Jordan    | 12      | Andrew  | 10      |
    | Austin | 11      | Jordan    | 12      | Kyle    | 12      |
    +--------+---------+-----------+---------+---------+---------+


