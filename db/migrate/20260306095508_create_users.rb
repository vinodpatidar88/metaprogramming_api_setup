class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :name
      t.string :user_name
      t.string :email, null: false
      t.string :password_digest
      t.string :mobile_number
      t.integer :status, default: 1, null: false
      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :status
    add_index :users, [:status, :email]
  end
end
