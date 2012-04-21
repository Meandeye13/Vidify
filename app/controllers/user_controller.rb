class UserController < ApplicationController


def home
	rootUrl = 'http://www.youtube.com/watch?v='
	videos = Video.select(:src_url).where('src_url LIKE ?', '%youtube.com%').order("created_time DESC").limit(10)
	@urls = []
	videos.each do |video|

		url = video['src_url']
		startIndex = url.rindex('/') + 1
		endIndex = url.index('?') - 1
		id = url[startIndex..endIndex]
		@urls.push(rootUrl + id)
	end

end

def show  
    session[:oauth] = Koala::Facebook::OAuth.new('287289548013361', 'fe9618a93f8eb1be8c0f017e996e4fb1', "http://localhost:3000" + '/callback')
    Koala.http_service.ca_file = "C:/RailsInstaller/cacert.pem"
    redirect_to session[:oauth].url_for_oauth_code(:permissions=>"read_stream") 
  end

  def callback
    if params[:code]
      # acknowledge code and get access token from FB
      session[:access_token] = session[:oauth].get_access_token(params[:code])
    end   

     # auth established, now do a graph call:
    redirect_to :action => "friendList"
  end

def friendList
	@api = Koala::Facebook::API.new(session[:access_token])

	@friends = @api.fql_query("select uid, name, pic_square from user where uid in (select uid2 from friend where uid1 = me())")
	@friends = @friends.sort_by{|friend| friend['name']}
end

end
