class Video < ActiveRecord::Base
	attr_accessible :user_id, :post_id, :created_time, :src_url, :img_src

	belongs_to :user
	validates :post_id, :uniqueness => true
end
