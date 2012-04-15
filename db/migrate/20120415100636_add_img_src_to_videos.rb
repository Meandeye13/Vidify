class AddImgSrcToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :img_src, :string
  end
end
