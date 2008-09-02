class PodcastsController < ApplicationController
  caches_page :index
  cache_sweeper :podcast_sweeper  , :only => [:index]


  def method_missing(name, *args)
    @podcast = Podcast.find_by_permalink(name.to_s)
    if @podcast
      render :action => "show", :podcast => @podcast
      cache_page if ActionController::Base.perform_caching
    else
      render :action => "notfound"
    end
  end
  
  
  def index
    @podcasts = Podcast.find(:all, :order => "number desc")
  end
  
  def show
     
  end

  def notfound
  
  end

end
