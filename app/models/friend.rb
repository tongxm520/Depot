class Friend < ActiveRecord::Base
  self.table_name="Friend"
  belongs_to :user,foreign_key: "ID1",class_name: "Highschooler"
end


