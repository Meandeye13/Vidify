class Video < ActiveRecord::Base
	attr_accessible :user_id, :post_id, :created_time, :src_url, :img_src

	belongs_to :user
	validates :post_id, :uniqueness => true

	scope :last_update, select(:created_time).find(:first, :order => "created_time DESC")
end
