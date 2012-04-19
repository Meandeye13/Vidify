class UserController < ApplicationController


def home

	@videos = Video.limit(4)

end

end
