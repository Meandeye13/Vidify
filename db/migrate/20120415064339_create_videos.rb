class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.primary_key :id
      t.integer :user_id
      t.timestamp :created_time

      t.timestamps
    end
    add_index :videos, [:user_id, :created_time]
  end
end
