class AddGroupIdToVideos < ActiveRecord::Migration
  def change
  	add_column :videos, :group_id, :integer
  end
end
