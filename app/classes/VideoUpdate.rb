
require 'koala'
require 'User'

class VideoUpdate

def self.updateVideos(token, friendIds)
	queryHash = {}
	for i in (0..(friendIds.length-1))
        id = friendIds[i]
        u = User.getUser(id)
        #lastUpdate = u.videos.last_update
        queryHash["query#{i}"] = "SELECT post_id, source_id, created_time, attachment FROM stream Where source_id=#{id} limit 100"
    end #AND created_time > #{lastUpdate}

    facebookApi = Koala::Facebook::API.new(token)

    posts = facebookApi.fql_multiquery(queryHash)

    @videoPosts = []
    @embedURL = []
    @videoID = []
    posts.each_value do |query|
      query.each do |post|

        if post['attachment'].has_key?('media')
          	media = post['attachment']['media']
          if media.length > 0 && media[0].has_key?('video')
              url = media[0]['video']['source_url']
              url = fixLink(url)
              user = User.getUser(post['source_id'])
              user.videos.create(:user_id => post['source_id'], :created_time => post['created_time'], :post_id => post['post_id'], :img_src => media[0]['src'], :src_url => url)
          end
        end
      end

    end


end

def self.fixLink(url)
  if(url.index('youtube.com') == nil)
    @embedURL.push(url)
    return url
  else
    fixURL = url[0, url.length-2] + '0'
    startPos = url.index('v/')

    if(startPos==nil)
      startPos = url.index('v=')
    end

    if(startPos!=nil)
      endPos = url.index('?')
      if(endPos != nil)
        vidID = url[startPos+2..endPos-1]
        @videoID.push(vidID)
      end
    end
    @embedURL.push(fixURL)
    return fixURL;
  end
end 

end