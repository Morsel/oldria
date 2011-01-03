module Paperclip
  class Attachment
    def width
      Paperclip::Geometry.from_file(self.url.gsub(' ','+')).width
    end

    def height
      Paperclip::Geometry.from_file(self.url.gsub(' ','+')).height
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