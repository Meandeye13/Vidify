class UserController < ApplicationController


def home
	rootUrl = 'http://www.youtube.com/watch?v='
	#videos2 = Video.where('src_url LIKE ?', '%youtube.com%').order("created_time DESC").limit(10) get user who posted the video (user pointer is invalidated doing projection on videos)
	videos = Video.select(:src_url).where('src_url LIKE ?', '%youtube.com%').order("created_time DESC").limit(10)
	@urls = []
	@users = []
	videos.each do |video|

		url = video['src_url']
		startIndex = url.rindex('/') + 1
		endIndex = url.index('?') - 1
		id = url[startIndex..endIndex]
		@urls.push(rootUrl + id)
	end

end

end
