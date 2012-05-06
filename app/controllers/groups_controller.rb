class GroupsController < ApplicationController

respond_to :html, :js

before_filter :load

def load
	@user = User.find(session[:user_id])
	@groups = @user.groups.all

end

def index

end

def new
	@api = Koala::Facebook::API.new(session[:access_token])

	@friends = @api.fql_query("select uid, name, pic_square from user where uid in (select uid2 from friend where uid1 = me())")
	@friends = @friends.sort_by{|friend| friend['name']}
end

def displayCreate
	@api = Koala::Facebook::API.new(session[:access_token])

	@friends = @api.fql_query("select uid, name, pic_square from user where uid in (select uid2 from friend where uid1 = me())")
	@friends = @friends.sort_by{|friend| friend['name']}

	@group
	respond_to do | format |  
        format.js {render :layout => false}  
    end
end

def create
	members = params[:friend]['uid']
	@group = @user.groups.new(:name => "test")
	@group.user = @user

	members.each do |uid|
		user = User.getUser(uid)
		@group.users.push(user)
	end
	@user.save
	respond_to do | format |  
        format.js {render :layout => false}  
    end
end


end