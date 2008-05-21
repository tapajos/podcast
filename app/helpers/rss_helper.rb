module RssHelper
  
  include PodcastsHelper
  
  def file_part(filename)
    return " - #{part(filename)}" unless part(filename).blank?
    ""
  end
  
  
end
