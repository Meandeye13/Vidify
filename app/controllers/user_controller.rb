class UserController < ApplicationController


def home
	rootUrl = 'http://www.youtube.com/watch?v='
	videos = Video.select(:src_url).order("created_time DESC").limit(10)
	@urls = []
	videos.each do |video|
		url = video['src_url']
		startIndex = url.rindex('/') + 1
		endIndex = url.index('?') - 1
		id = url[startIndex..endIndex]
		@urls.push(rootUrl + id)
	end

end

end
