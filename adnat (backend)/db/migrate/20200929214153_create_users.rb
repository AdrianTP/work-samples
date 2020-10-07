class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email_address
      t.string :password_digest
      t.belongs_to :organisation, null: false, foreign_key: true

      t.timestamps
    end
    add_index :users, :email_address, unique: true
  end
end
