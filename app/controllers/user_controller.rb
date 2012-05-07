class UserController < ApplicationController

def login
	session[:oauth] = Koala::Facebook::OAuth.new('287289548013361', 'fe9618a93f8eb1be8c0f017e996e4fb1', "http://localhost:3000" + '/callback')
    Koala.http_service.ca_file = "C:/RailsInstaller/cacert.pem"
    redirect_to session[:oauth].url_for_oauth_code(:permissions=>"read_stream") 
end

def callback
	if params[:code]
		# acknowledge code and get access token from FB
		session[:access_token] = session[:oauth].get_access_token(params[:code])
		session[:api] = Koala::Facebook::API.new(session[:access_token])
	end   

	# auth established, now do a graph call:
	redirect_to :action => "home"
end

def home
	if (!session[:user_id].present?)
		id_response = session[:api].get_object("me", "fields"=>"id")
		newUser = User.find_or_create_by_user_id(:user_id => id_response['id'])
		session[:user_id] = newUser.id
	end
	rootUrl = 'http://www.youtube.com/watch?v='
	#videos2 = Video.where('src_url LIKE ?', '%youtube.com%').order("created_time DESC").limit(10) get user who posted the video (user pointer is invalidated doing projection on videos)
	@videos = Video.where('src_url LIKE ?', '%youtube.com%').order("created_time DESC").limit(10)
	@recommendedVideos = Video.select(:src_url).limit(3)
	@urls = []

	users = ""
	@videos.each do |video|
		users = users + (video.user.user_id.to_s) + ","
	end
	# remove the last ',' to make a valid query string
	users = users[0..(users.length-2)]

	@query = "SELECT uid,name FROM user WHERE uid in(#{users})"
	
	api = session[:api]
	#api = Koala::Facebook::API.new(session[:access_token])
	@friends = api.fql_query("SELECT uid,name FROM user WHERE uid in(#{users})");

	#convert array of hashes to a hash where key = uid and value = name
	@friends = @friends.map {|friend| {friend["uid"] => friend["name"]}}
	@friends = @friends.flatten.reduce(:merge)

	@recentVideos = {}
	@wtf = []
	@videos.each do |video|
		url = video[:src_url]
		startIndex = url.rindex('/') + 1
		endIndex = url.index('?') - 1
		id = url[startIndex..endIndex]
		url = rootUrl + id

		friendId = video.user.user_id.to_s
		name = @friends[Integer(friendId)]
		@recentVideos[name] = url
	end

end

def friendList
	api = session[:api]

	@friends = api.fql_query("select uid, name, pic_square from user where uid in (select uid2 from friend where uid1 = me())")
	@friends = @friends.sort_by{|friend| friend['name']}
end

def myWall
	myId = []
	api = session[:api]
	me = api.get_object('me')
	myId.push(me['id'].to_s)
	id = {}
	id['uid'] = myId
	redirect_to :action => "showVideos", :friend => id, :extra => 'groups'
end

def showVideos 
	@videoLinks = []
	myId = session[:user_id]

	videos = Video.where('src_url LIKE ?','%youtube.com%').order("created_time DESC")
	
	extra = params[:extra]
	if(extra == 'sent')
		myGroups = Group.where('user_id = ?',myId).all()
		videos.each do |video|
			if(myGroups.include?(video.group))
				@videoLinks.push(video.src_url)
			end
		end
	end

	if(params[:friend] == nil)
		return
	end
	friendIds = params[:friend]['uid']
	
	
	#users = ""
	#@videos.each do |video|
	#	users = users + (video.user.user_id.to_s) + ","
	#end
	groupIds = []

	if(extra == 'groups')
		groupMembers = GroupMember.where('user_id = ?',myId).all()
		groupMembers.each do |groupMem|
			if(groupMem.group.user_id != myId)
				groupIds.push(groupMem.group.id)
			end
		end
	end
	
	if(friendIds != nil)
		videos.each do |video|
			if((friendIds.include?(video.user.user_id.to_s)&&(video.group == nil || video.group.user_id != myId ))||((video.group != nil)&&groupIds.include?(video.group.id)))
				@videoLinks.push(video.src_url)
			end
		end
	end
end

def sendVideo

end

def sentVideos
	redirect_to :action => "showVideos", :extra => 'sent'
end
end
