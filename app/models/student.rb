class Student < ActiveRecord::Base
  attr_accessible :sName, :GPA,:sizeHS
  has_many :applies,inverse_of: :student

  #SELECT id,sName,GPA FROM `students` WHERE (GPA > 3.6)
  def self.greater_than(gpa)
    self.where("GPA > ?",gpa).select("id,sName,GPA")
    #.where(["id = ?", id]).select("name, website, city").first
  end

  #SELECT sName,major,applies.college_id FROM `students` RIGHT OUTER JOIN applies ON applies.student_id=students.id ORDER BY sName desc,major asc
  def self.get_major
    self.joins('RIGHT OUTER JOIN applies ON applies.student_id=students.id').select("sName,major,applies.college_id").order("sName desc,major asc")
  end

  #SELECT students.sName,applies.major,applies.college_id FROM `students` INNER JOIN `applies` ON `applies`.`student_id` = `students`.`id` ORDER BY sName desc,major asc
  def self.student_major
    self.joins(:applies).select("students.sName,applies.major,applies.college_id").order("sName desc,major asc")
  end

  #SELECT students.sName, count(applies.id) as applycount FROM `students` INNER JOIN `applies` ON `applies`.`student_id` = `students`.`id` GROUP BY applies.student_id
  def self.apply_count_by_student
    self.joins(:applies).
    group("applies.student_id").
    select("students.sName, COUNT(applies.id) as applycount")
  end

  #SELECT sName,major FROM students,applies where students.id=applies.student_id
  #Student.two_tables.entries
  def self.two_tables
    self.connection.execute("SELECT sName,major FROM students,applies WHERE students.id=applies.student_id")
  end

  #SELECT students.sName,students.GPA,applies.decision FROM `students` INNER JOIN `applies` ON `applies`.`student_id` = `students`.`id` INNER JOIN `colleges` ON `colleges`.`id` = `applies`.`college_id` WHERE (students.sizeHS < 1000 AND applies.major='CS' AND colleges.cName='Stanford')
  def self.select_students
    @students=self.joins(applies: :college).
    where("students.sizeHS < ? AND applies.major=? AND colleges.cName=?",1000,'CS','Stanford').
    select("students.sName,students.GPA,applies.decision") 
    #ActiveRecord::Relation

    rows=[]
    @students.each do |a|
      row=[]
      row << a.sName
      row << a.GPA
      row << a.decision
      rows << row
    end
    rows
  end

  #Student.three_tables.entries
  def self.three_tables
    query=sanitize_sql(["SELECT students.sName,students.GPA,applies.decision FROM students,applies,colleges WHERE students.id=applies.student_id AND colleges.id=applies.college_id AND  students.sizeHS < '?' AND applies.major='?' AND colleges.cName='?'",1000,'CS','Stanford'])
    self.connection.execute(query)
  end

  #google: rails subquery
  #SELECT id,sName FROM `students` WHERE `students`.`id` IN (SELECT student_id FROM `applies` WHERE `applies`.`major` = 'CS')
  def self.subquery_by_major
    self.where(id: Apply.select("student_id").where(major: 'CS')).select("id,sName")
  end

  def self.test_sql_injection
    id="123 OR 1=1"
    #self.connection.execute("SELECT * FROM students WHERE id=#{id}")
    self.find_by_sql("SELECT * FROM students WHERE id=#{id}")
  end

  def self.secure_sql
    id="123 OR 1=1"
    query=sanitize_sql(["SELECT * FROM students WHERE id=?",id])
    #self.connection.execute(query)
    self.find_by_sql(query)
  end

  #I am getting fast queries (around 0.5 seconds) with a slow cpu, selecting 10 random rows in a 400K registers MySQL database non-cached 2Gb size. 
  def self.random_row
    total_count=self.count
    query=sanitize_sql(["SELECT id,sName FROM students WHERE RAND() * ? < 20 ORDER BY RAND() LIMIT 0,10", total_count])
    self.connection.execute(query)
  end

  def self.get_avg_gpa_difference
    query=sanitize_sql("select CS.avgGPA - NonCS.avgGPA
from (select avg(GPA) as avgGPA from students
      where id in (
         select student_id from applies where major = 'CS')) as CS,
     (select avg(GPA) as avgGPA from students
      where id not in (
         select student_id from applies where major = 'CS')) as NonCS")
    self.connection.execute(query)
    #[[0.19428573335920074]]
  end
end

=begin
Student.where(id: Apply.select("student_id").where(major: 'CS')).select("id,sName").to_sql

# 1. Build you subquery with AREL.
subquery = Account.where(...).select(:id)
# 2. Use the AREL object in your query by converting it into a SQL string
query = User.where("users.account_id IN (#{subquery.to_sql})")
=end










