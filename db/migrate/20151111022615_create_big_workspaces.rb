class CreateBigWorkspaces < ActiveRecord::Migration
  def change
    create_table :big_workspaces do |t|
      t.string :cohort
      t.string :teacher

      t.timestamps null: false
    end
  end
end
