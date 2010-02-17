require 'cgi'

class ITunesWrapper
  TEMPLATE = %{<?xml version="1.0"?><?quicktime type="application/x-quicktime-media-link"?><embed src="file:/PATH"/>}

  def initialize(path_to_movie)
    @movie = path_to_movie
  end
  
  def to_s
    TEMPLATE.gsub("PATH", CGI.escape(@movie).gsub("+", "%20"))
  end
  
  def filename
    File.basename(@movie, ".avi") + ".mov"
  end
  
  def import(itunes_media_directory)
    File.open(File.join(itunes_media_directory, filename), "w") do |f|
      f.write(self.to_s)
    end
  end
end
