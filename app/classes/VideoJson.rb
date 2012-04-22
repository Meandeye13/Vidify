require 'json'
require 'rubygems'
require 'json'
require 'net/http'

class VideoJson
     @gerd="Tebow"
   
  def initialize
 
   end
  def getJson()
    
        url = "http://gdata.youtube.com/feeds/api/videos/NWHfY_lvKIQ?v=2&alt=json"
       resp = Net::HTTP.get_response(URI.parse(url))
       data = resp.body

   # we convert the returned JSON data to native Ruby
   # data structure - a hash
   result = JSON.parse(data)
    return result
    # v = ActiveSupport::JSON.decode(string);
  end

  def out()

    return "Charzard"
  end





end