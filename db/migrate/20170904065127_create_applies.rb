class CreateApplies < ActiveRecord::Migration
  def change
    create_table :applies do |t|
      t.integer :student_id
      t.integer :college_id
      t.string :major
      t.boolean :decision

      t.timestamps
    end
  end
end
