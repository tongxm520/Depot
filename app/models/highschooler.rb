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
end

