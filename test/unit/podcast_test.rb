require File.dirname(__FILE__) + '/../test_helper'
require 'mocha'
require 'stubba'
require 'find'

class PodcastTest < Test::Unit::TestCase

  fixtures  :podcasts
  
  FULL_FILE_NAME = "#{RAILS_ROOT}/public/podcasts/podcast-de-exemplo.mp3"
  
  def setup
    @podcasts_001 = podcasts(:podcasts_001)
    @podcasts_002 = podcasts(:podcasts_002)
    @podcasts_003 = podcasts(:podcasts_003)
    turn_methods_public(Podcast)
  end
  
  def test_get_files_list
    Find.expects(:find).with("#{RAILS_ROOT}/public/podcasts/").yields("/#{RAILS_ROOT}/public/podcasts/podcast-de-exemplo.mp3")
    assert_equal ['podcast-de-exemplo.mp3'], Podcast.get_files_list(@podcasts_001.file_prefix)
  end

  def test_get_files_list_with_parts
    Find.expects(:find).with("#{RAILS_ROOT}/public/podcasts/").yields("/#{RAILS_ROOT}/public/podcasts/podcast-de-exemplo-parte2.mp3")
    assert_equal ['podcast-de-exemplo-parte2.mp3'], Podcast.get_files_list(@podcasts_001.file_prefix)
  end
  
  def test_get_files_list_when_file_is_zip
    Find.expects(:find).with("#{RAILS_ROOT}/public/podcasts/").yields("/#{RAILS_ROOT}/public/podcasts/podcast-de-exemplo.zip")
    assert_equal [], Podcast.get_files_list(@podcasts_001.file_prefix)
  end

  def test_files
    Podcast.expects(:get_files_list).with("podcast-de-exemplo").returns(['podcast-de-exemplo.mp3'])
    file_name = "podcast-de-exemplo.mp3"
    duration = "03:20"
    size = "140 MB"
    Podcast.expects(:duration).with(file_name).returns(duration)
    Podcast.expects(:file_size).with(file_name).returns(size)
    Podcast.expects(:absolute_duration).with(file_name).returns(200)
    expected_file = {:file_name => file_name, :duration => duration, :absolute_duration => 200, :size => size, :zip_file_name => "podcast-de-exemplo.zip"}
    assert_equal [expected_file], @podcasts_001.files
  end
  
  def test_recording_date
    assert "17/05/2007", @podcasts_001.recording_date
  end

  def test_recording_date_full
    assert_equal "Tue, 20 May 2008 00:00:00 -0300", @podcasts_001.recording_date_full
  end

  def test_duration
    mp3_mock = mock()
    mp3_mock.expects(:length).returns(12000)
    FileTest.expects(:exists?).with(FULL_FILE_NAME).returns(true)
    Mp3Info.expects(:open).with(FULL_FILE_NAME).yields(mp3_mock)
    assert_equal "03:20", Podcast.duration("podcast-de-exemplo.mp3")
  end
  
  def test_file_size
    FileTest.expects(:exists?).with(FULL_FILE_NAME).returns(true)
    File.expects(:size).with(FULL_FILE_NAME).returns(147666822)
    assert_equal "140 MB", Podcast.file_size("podcast-de-exemplo.mp3")
  end
  
  def test_zip_file
    assert_equal "podcast-de-exemplo.zip", @podcasts_001.zip_file("podcast-de-exemplo.mp3")
  end
  
  def test_before_save
    podcast = Podcast.new(:permalink => "tapajos", :file_prefix => "tapa", :number => 5)
    podcast.save
    assert_equal "podcast-5-tapajos", podcast.permalink
  end
  
  def test_validates_presence_of
    podcast = Podcast.new
    podcast.valid?
    assert_equal "can't be blank", podcast.errors[:permalink]
    assert_equal "can't be blank", podcast.errors[:file_prefix]
    assert_equal "can't be blank", podcast.errors[:number]
  end
  
  def test_uniqueness_of_file_prefix
    verify_uniqueness({:permalink => "podcasts_001", :file_prefix => "podcast-de-exemplo", :number => 5}, :file_prefix)
  end

  def test_uniqueness_of_file_number
    verify_uniqueness({:permalink => "podcasts_001", :file_prefix => "podcasts_001-novo", :number => 16}, :number)
  end
  
  def verify_uniqueness(params, field)
    podcast = Podcast.new(params)
    podcast.valid?
    assert_equal "has already been taken", podcast.errors[field]
  end
  
end
