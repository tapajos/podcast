class Admin::PodcastsController < ResourceController::Base
  
  cache_sweeper :podcast_sweeper
  
  include AuthenticatedSystem
  before_filter :login_required
  
end
