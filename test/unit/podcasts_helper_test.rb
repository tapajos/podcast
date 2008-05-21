require File.dirname(__FILE__) + '/../test_helper'
require 'mocha'

class PodcastsHelperTest < Test::Unit::TestCase
  
  include PodcastsHelper
  include ActionView::Helpers::TextHelper
  
  def test_format_duration
    assert_equal "1 minuto", format_duration("00:01")
    assert_equal "2 minutos", format_duration("00:02")
    assert_equal "1 hora e 1 minuto", format_duration("01:01")
    assert_equal "1 hora e 2 minutos", format_duration("01:02")
    assert_equal "2 horas e 1 minuto", format_duration("02:01")
    assert_equal "2 horas e 2 minutos", format_duration("02:02")
  end

  def test_part_when_is_one_part
    assert_equal "Parte 1", part("arquivo-parte1.mp3")
  end
  
  def test_part
    assert_equal "", part("arquivo.mp3")
  end

end