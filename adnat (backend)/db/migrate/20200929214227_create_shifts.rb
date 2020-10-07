class CreateShifts < ActiveRecord::Migration[6.0]
  def change
    create_table :shifts do |t|
      t.datetime :start
      t.datetime :finish
      t.float :break_length
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
