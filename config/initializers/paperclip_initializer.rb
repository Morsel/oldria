module Paperclip
  class Attachment
    def width style = 'medium'
      Paperclip::Geometry.from_file(self.url(style).gsub(' ','+')).width
    end

    def height style = 'medium'
      Paperclip::Geometry.from_file(self.url(style).gsub(' ','+')).height
    end
    
    def image?(style = default_style)
      to_file(style).image?
    end
  end
  
  module Upfile
    def image?
      ["image/jpeg", "image/tiff", "image/png", "image/gif", "image/bmp"].include?(content_type)
    end
  end
end