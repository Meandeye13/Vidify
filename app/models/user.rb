class User < ActiveRecord::Base
	attr_accessible :user_id

	has_many :videos, :dependent => :destroy
	has_many :group_members
	has_many :groups, :through => :group_members

	validates :user_id, :uniqueness => true

	def self.getUser(userId)
		return where(:user_id => userId).first()
	end
end
