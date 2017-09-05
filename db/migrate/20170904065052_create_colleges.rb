class CreateColleges < ActiveRecord::Migration
  def change
    create_table :colleges do |t|
      t.string :cName
      t.string :state
      t.integer :enrollment

      t.timestamps
    end
  end
end
