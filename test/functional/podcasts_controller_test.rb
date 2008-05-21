require File.dirname(__FILE__) + '/../test_helper'

class PodcastsControllerTest < ActionController::TestCase
  
  fixtures :podcasts
  
  def test_index
    all_podcasts = (Podcast.find(:all).sort_by {|podcast| podcast.number }).reverse
    get :index
    assert_equal all_podcasts, assigns(:podcasts)
  end
  
  def test_show
    get :show, :id => 1
    assert_equal 1, assigns(:podcast).id
  end
  
end
