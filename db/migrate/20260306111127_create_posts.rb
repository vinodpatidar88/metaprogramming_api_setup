class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts, id: :uuid do |t|
      t.string :title
      t.string :subtitle
      t.integer :status
      t.references :user, type: :uuid, foreign_key: true
      t.string :url
      t.string :image_url
      t.string :video_url
      t.timestamps
    end
    
    add_index :posts, :status
    add_index :posts, [:user_id, :status]
    add_index :posts, :url
  end
end
