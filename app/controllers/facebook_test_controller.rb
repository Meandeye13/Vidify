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
      
    @api = Koala::Facebook::API.new(session[:access_token])
    begin
      @graph_data = @api.get_object("/me/statuses", "fields"=>"message")
    rescue Exception=>ex
      puts ex.message
    end
    
  
    respond_to do |format|
     format.html {   }       
    end
    
  
  end

end
