class Apply < ActiveRecord::Base
  attr_accessible :student_id, :college_id,:major,:decision

  belongs_to :student,inverse_of: :applies
  belongs_to :college,inverse_of: :applies

  #SELECT students.sName,major FROM `applies` INNER JOIN `students` ON `students`.`id` = `applies`.`student_id`
  def self.student_major
    self.joins(:student).select("students.sName,major")
  end

  #SELECT students.sName,students.GPA,applies.decision FROM students 
  #JOIN applies ON applies.student_id=students.id
  #JOIN colleges ON applies.college_id=colleges.id
  #WHERE students.sizeHS < 1000 AND 
  #applies.major='CS' AND
  #colleges.cName='Stanford'
  def self.select_students
    @applies=self.joins(:student).joins(:college).
    where("students.sizeHS < ? AND applies.major=? AND colleges.cName=?",1000,'CS','Stanford').
    select("students.sName,students.GPA,applies.decision")
    #ActiveRecord::Relation
    rows=[]
    @applies.each do |a|
      row=[]
      row << a.sName
      row << a.GPA
      row << a.decision
      rows << row
    end
    rows
  end
end
