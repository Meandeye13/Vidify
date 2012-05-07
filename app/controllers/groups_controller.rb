class GroupsController < ApplicationController

respond_to :html, :js

before_filter :load

def load
	@user = User.find(session[:user_id])
	@groups = @user.groups.all

	@api = Koala::Facebook::API.new(session[:access_token])

	@friends = @api.fql_query("select uid, name, pic_square from user where uid in (select uid2 from friend where uid1 = me())")
	@friends = @friends.sort_by{|friend| friend['name']}
end

def index
	@friends = @friends.map {|friend| {friend["uid"] => {"name" => friend["name"], "pic_square" => friend["pic_square"] } } }
	@friends = @friends.flatten.reduce(:merge)
end

def displayCreate
	respond_to do | format |  
        format.js {render :layout => false}  
    end
end

def create
	members = params[:friend]['uid']
	@group = @user.groups.new(:name => params[:groupName])
	@group.user = @user

	members.each do |uid|
		user = User.getUser(uid)
		@group.users.push(user)
	end
	@user.save
	@groups = @user.groups.all

	@friends = @friends.map {|friend| {friend["uid"] => {"name" => friend["name"], "pic_square" => friend["pic_square"] } } }
	@friends = @friends.flatten.reduce(:merge)
	respond_to do | format |  
        format.js {render :layout => false}  
    end
end


end