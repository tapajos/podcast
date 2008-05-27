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
  
  def test_method_missing_when_permalink_is_not_found
    assert_raise(ActionController::UnknownAction) { get :not_found }
  end
  
  def test_method_missing_when_permalink_is_found
    get "podcast-17-rpb"
    assert_equal podcasts(:podcasts_001), assigns(:podcast)
    assert_template "show"  
  end
  
end
