require 'json'
require 'rubygems'
require 'json'
require 'net/http'

class VideoJson
 @gerd="Tebow"
 @id=""
 def initialize(id)
  @id=id
end


def setId(id)
  @id=id;
end


def getId
  return @id
end


def getJson()

  url = "http://gdata.youtube.com/feeds/api/videos/"+@id+"?v=2&alt=json"
  resp = Net::HTTP.get_response(URI.parse(url))
  data = resp.body

   # we convert the returned JSON data to native Ruby
   # data structure - a hash
   result = JSON.parse(data)
   return result
    # v = ActiveSupport::JSON.decode(string);
  end




end