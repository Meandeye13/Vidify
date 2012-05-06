class Group < ActiveRecord::Base
	attr_accessible :ownerid, :name, :user_id


	belongs_to :user
	has_many :group_members, :videos
	has_many :users, :through => :group_members

	accepts_nested_attributes_for :users
end
