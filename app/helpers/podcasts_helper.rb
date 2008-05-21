module PodcastsHelper
  
  REGEX_DURATION = /(\d\d):(\d\d)/
  
  def format_duration(duration)
    duration =~ REGEX_DURATION
    hours = ""
    if $1 != "00" 
      hours = $1.to_i 
      hours = (pluralize hours, "hora") + " e "
    end
    minutes = $2.to_i
    minutes = pluralize minutes, "minuto"
    
    "#{hours}#{minutes}"
  end
  
  def part(filename)
    part = ""
    if filename =~ /.*-parte(\d).mp3/
      part = "Parte #{$1}"
    end
    part
  end
  
  
end
