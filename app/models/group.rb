class Group < ActiveRecord::Base
	attr_accessible :ownerid
	attr_accessible :name
	has_many :users
end
