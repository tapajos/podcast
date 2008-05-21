class RssController < ApplicationController
  
  def index
    @podcasts = Podcast.find(:all, :order => 'number desc')
    render :layout => false
  end
  
  
end
