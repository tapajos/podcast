require 'bluecloth'

class MarkdownOnRails
  
  class BlueCloth < BlueCloth

    MAX_HEADING_DEPTH = 10

    attr_accessor :heading_mapping

    old_to_html = instance_method(:to_html)

    define_method(:to_html) { |*args|
      text = old_to_html.bind(self).call(*args)
      map_headings(text)
    }

    protected 

    def map_headings(text)
      # puts "map_headings"
      # puts "@heading_mapping: #{@heading_mapping}"
      @heading_mapping ||= 0
      MAX_HEADING_DEPTH.downto(1) do |n|
        open = "<h#{n}>"
        close = "</h#{n}>"
        text.gsub! open, "<h#{(n + @heading_mapping).to_s}>"
        text.gsub! close, "</h#{(n + @heading_mapping).to_s}>"
      end
      text
    end

  end
  
  @@heading_mapping = 0

  def initialize(view)
    @view = view
  end
  
  def self.map_headings_down_by(mapping)
    @@heading_mapping = mapping
  end
  
  def render(template, local_assigns) 

    assigns = @view.assigns.dup
  
    if content_for_layout = @view.instance_variable_get("@content_for_layout")
      assigns['content_for_layout'] = content_for_layout
    end
    result = @view.instance_eval do
		  assigns.each do |key,val|
		    instance_variable_set "@#{key}", val
	    end
		  local_assigns.each do |key,val|
	  		class << self; self; end.send(:define_method,key) { val }
			end
      ERB.new(template, nil, '-').result(binding)
    end
    
    doc = BlueCloth::new(result)
    doc.heading_mapping = @@heading_mapping
    doc.to_html
  end 

  module VERSION
    MAJOR = 0
    MINOR = 3
    TINY  = 0
    STRING = [MAJOR, MINOR, TINY].join('.')          
  end

end



