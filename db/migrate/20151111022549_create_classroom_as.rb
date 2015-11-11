class CreateClassroomAs < ActiveRecord::Migration
  def change
    create_table :classroom_as do |t|
      t.string :cohort
      t.string :teacher

      t.timestamps null: false
    end
  end
end
