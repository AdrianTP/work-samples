class ExtractBreaksFromShifts < ActiveRecord::Migration[6.0]
  def up
    create_table :breaks do |t|
      t.datetime :start
      t.datetime :finish
      t.float :length # for backwards-compatibility with old shift table
      t.belongs_to :shift, null: false, foreign_key: true

      t.timestamps
    end

    Shift.all.each do |shift|
      Break.create!(length: shift.break_length)
    end

    remove_column :shifts, :break_length
  end

  def down
    add_column :shifts, :break_length, :float

    Shift.reset_column_information

    Break.all.each do |break_instance|
      target_shift = break_instance.shift

      if break_instance.length.nil?
        break_length = (break_instance.finish - break_instance.start)/3600
        target_shift.update!(break_length: break_length)
      else
        target_shift.update!(break_length: break_instance.length)
      end
    end
  end
end
