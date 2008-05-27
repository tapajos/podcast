class PodcastsController < ApplicationController
  
  def method_missing(name, *args)
    @podcast = Podcast.find_by_permalink(name.to_s)
    if @podcast
      render :action => "show"
    else
      raise ::ActionController::UnknownAction
    end
  end
  
  
  def index
    @podcasts = Podcast.find(:all, :order => "number desc")
  end
  
  def show
    @podcast = Podcast.find(params[:id])
  end
end
