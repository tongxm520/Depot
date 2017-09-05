class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :sName
      t.float :GPA #a grade point average
      t.integer :sizeHS #size of High School
      t.timestamps
    end
  end
end
