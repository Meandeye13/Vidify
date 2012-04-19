class FacebookTestController < ApplicationController

require 'koala'

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
    redirect_to :action => "home"
  end

  def home
     @api = Koala::Facebook::API.new(session[:access_token])

      friendIds = @api.get_object("me/friends", "fields"=>"id")
      ids = friendIds.map(&:values).flatten

      @videos = Video.joins(:user).find(:all, :conditions => ["users.user_id in (?)", ids])
      friendIds.each do |id|
        User.create(:user_id => id['id'])
      end
      
      @queryHash = {}
      count = 1
      for i in (0..10)
        id = friendIds[i]['id']
        u = User.getUser(id)
        begin
         @queryHash["query#{i}"] = "SELECT post_id, source_id, created_time, attachment FROM stream Where source_id=#{id} limit 100"
        rescue Exception => e
          puts ex.message
        end
      end
     
      # friendIds.each do |idHash|
      #   id = idHash['id']
        
      #   count += 1
      # end
    @queryHash["query#{11}"] = "SELECT post_id, source_id, created_time, attachment FROM stream Where source_id=me() limit 10000"
    @posts = @api.fql_multiquery(@queryHash)

    @videoPosts = []
    @embedURL = []
    @videoID = []
    @posts.each_value do |query|
      query.each do |post|

        if post['attachment'].has_key?('media')
          if post['attachment']['media'].length > 0
            if post['attachment']['media'][0].has_key?('video') 
              url = post['attachment']['media'][0]['video']['source_url']
              if(url.index('youtube.com') == nil)
                  @embedURL.push(url)
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
              end
              @videoPosts.push(post['attachment'])
              #user = User.where(:user_id => post['source_id']).first()
             # user.videos.create(:user_id => post['source_id'], :created_time => post['created_time'], :post_id => post['post_id'], :img_src => post['attachment']['media'][0]['src'], :src_url => post['attachment']['media'][0]['video']['source_url'])
            end
          end
        end
      end

    end

  end

end
