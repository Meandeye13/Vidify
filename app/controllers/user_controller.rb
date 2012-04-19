class UserController < ApplicationController


def home
	rootUrl = 'http://www.youtube.com/watch?v='
	@videos = Video.limit(10)
	@urls = []
	for i in (0..(@videos.length-1))
		startIndex = @videos[i].src_url.rindex('/') + 1
		endIndex = @videos[i].src_url.index('?') - 1
		id = @videos[i].src_url[startIndex..endIndex]
		@urls.push(rootUrl + id)
	end

end

end
