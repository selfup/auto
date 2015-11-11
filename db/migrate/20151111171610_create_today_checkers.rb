class CreateTodayCheckers < ActiveRecord::Migration
  def change
    create_table :today_checkers do |t|
      t.string :repo_day

      t.timestamps null: false
    end
  end
end
