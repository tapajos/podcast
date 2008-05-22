require File.dirname(__FILE__) + '/../test_helper'
require 'mocha'

class ApplicationHelperTest < Test::Unit::TestCase
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::AssetTagHelper
  include ApplicationHelper
  
  def test_page_title_when_title_is_not_defined
    assert_equal "Rails Podcast Brasil", page_title(nil)
  end
  
  def test_page_title_when_title_is_defined
    assert_equal "title - Rails Podcast Brasil", page_title("title")
  end
  
end