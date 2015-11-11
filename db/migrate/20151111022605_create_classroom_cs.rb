class CreateClassroomCs < ActiveRecord::Migration
  def change
    create_table :classroom_cs do |t|
      t.string :cohort
      t.string :teacher

      t.timestamps null: false
    end
  end
end
