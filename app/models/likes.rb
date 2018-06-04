class Likes < ActiveRecord::Base
  self.table_name="Likes"

  belongs_to :follower,foreign_key: "ID1",class_name: "Highschooler"
  belongs_to :followee,foreign_key: "ID2",class_name: "Highschooler"
end

