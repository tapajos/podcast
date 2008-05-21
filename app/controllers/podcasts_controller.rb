class PodcastsController < ApplicationController
  
  def index
    @podcasts = Podcast.find(:all, :order => "number desc")
  end
  
  def show
    @podcast = Podcast.find(params[:id])
  end
end
