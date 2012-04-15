class AddIndex < ActiveRecord::Migration
  def up
  	add_index :users, :user_id, :unique => true
  end

  def down
  end
end
