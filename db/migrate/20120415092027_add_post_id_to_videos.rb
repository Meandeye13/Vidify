class AddPostIdToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :post_id, :string

    add_index :videos, :post_id, :unique => true
  end
end
