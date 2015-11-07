class CreateClassroomBs < ActiveRecord::Migration
  def change
    create_table :classroom_bs do |t|
      t.string :cohort
      t.string :teacher

      t.timestamps null: false
    end
  end
end
