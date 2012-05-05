class Keywords < ActiveRecord::Base
	
	
	validates :user_id, :uniqueness => true
      belongs_to :video
	def self.getUser(userId)
		return where(:user_id => userId).first()
	end
end
