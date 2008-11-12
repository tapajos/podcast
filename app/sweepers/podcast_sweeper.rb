class PodcastSweeper < ActionController::Caching::Sweeper
  observe Podcast 
  
  def after_create(podcast)
    expire_cache_for(podcast)
  end
  
  def after_update(podcast)
    expire_cache_for(podcast)
  end
  
  def after_destroy(podcast)
    expire_cache_for(podcast)
  end
  
  private
  def expire_cache_for(record)
    cache_dir = ActionController::Base.page_cache_directory
    FileUtils.rm_r(Dir.glob("#{cache_dir}/index.html")) rescue Errno::ENOENT
    FileUtils.rm_r(Dir.glob("#{cache_dir}/podcasts.html")) rescue Errno::ENOENT
    FileUtils.rm_r(Dir.glob("#{cache_dir}/podcast/*.*")) rescue Errno::ENOENT
  end
end

