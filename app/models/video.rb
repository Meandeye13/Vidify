class Video < ActiveRecord::Base
	attr_accessible :user_id, :post_id, :created_time, :src_url, :img_src, :group_id
    has_many :keywords, :dependent => :destroy
	belongs_to :user
	belongs_to :group
	validates :post_id, :uniqueness => true
    
	scope :last_update, select(:created_time).find(:first, :order => "created_time DESC")
end


