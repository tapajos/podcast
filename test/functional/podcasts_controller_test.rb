require File.dirname(__FILE__) + '/../test_helper'

class PodcastsControllerTest < ActionController::TestCase
  
  fixtures :podcasts
  
  def test_index
    all_podcasts = (Podcast.find(:all).sort_by {|podcast| podcast.number }).reverse
    get :index
    assert_equal all_podcasts, assigns(:podcasts)
  end
  
  def test_method_missing_when_permalink_is_not_found
    get "podcast12312432132131"
    assert_template "notfound" 
  end
  
  def test_method_missing_when_permalink_is_found
    get "podcast-17-rpb"
    assert_equal podcasts(:podcasts_001), assigns(:podcast)
    assert_template "show"  
  end
  
end
