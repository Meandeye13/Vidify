class AddSrcUrlToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :src_url, :string
  end
end
