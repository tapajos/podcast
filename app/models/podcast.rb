class Podcast < ActiveRecord::Base
  
  include ActiveSupport::CoreExtensions::String::Inflections
  
  before_save :do_permalink
  
  validates_presence_of :permalink
  validates_presence_of :file_prefix
  validates_presence_of :number
  validates_uniqueness_of :file_prefix
  validates_uniqueness_of :number
  
  def do_permalink
    self.permalink = "podcast-#{number}-#{permalink}"
  end
  
  def recording_date
    self.recorded_on.strftime('%d/%m/%Y') unless self.recorded_on.blank?
  end
  
  def recording_date_full
    self.recorded_on.strftime('%a, %d %b %Y %H:%M:%S -0300')
  end
  
  def zip_file(file_name)
    file_name.gsub(/\.mp3$/, ".zip")
  end
  
  def files
    files_list = []
    Podcast.get_files_list(self.file_prefix).each do |file_name|
      item = {:file_name => file_name, 
              :duration => Podcast.duration(file_name),
              :absolute_duration => Podcast.absolute_duration(file_name), 
              :size => Podcast.file_size(file_name), 
              :zip_file_name => zip_file(file_name)}
      files_list << item  
    end
    files_list
  end
  
  class << self
    
    def get_files_list(file_prefix)
      #Acho válido comentar que a barra final é necessária apenas porque lá é um link simbolico.
      path = "#{RAILS_ROOT}/public/podcasts/"
      file_list = []
      Find.find(path) do |file|
        file_list << file.gsub(/.*\/podcasts\//, "") if file.include?(file_prefix) && file.include?(".mp3")
      end
      file_list.sort
    end
  
    def duration(file)
      Time.at(absolute_duration(file)).gmtime.strftime('%R')
    end
    
    def absolute_duration(file)
      file_name = get_full_filename(file)
      if FileTest.exists?(file_name)
        Mp3Info.open(file_name) do |mp3|
          return mp3.length.round
        end
      end
    end
    
    def file_size(file)
      size = "0MB"
      file_name = get_full_filename(file)
      if FileTest.exists?(file_name)
        size = "#{File.size(file_name)/1.megabytes} MB"
      end
      size
    end
    
    def get_full_filename(file)
      RAILS_ROOT + "/public/podcasts/#{file}"
    end
    
  end
  
end
