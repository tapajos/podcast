class Admin::PodcastsController < ResourceController::Base
  
  include AuthenticatedSystem
  before_filter :login_required
  
end
