
module Paperclip
  class Attachment
    # require 'net/http'
    def width
      if image_exist?     
        Paperclip::Geometry.from_file(self.url(:medium).gsub(' ','+')).width
      else
        "200"
      end
    end

    def height
      if image_exist?
        Paperclip::Geometry.from_file(self.url(:medium).gsub(' ','+')).height
      else
        "200"
      end
    end
    
    def image?(style = default_style)
      to_file(style).image?
    end
    #rails3 check if image exist or not for error=>#Paperclip::Errors::NotIdentifiedByImageMagickError
    def image_exist?
      uri = URI(self.url(:medium))
      request = Net::HTTP.new uri.host
      response= request.request_head uri.path
      return response.code.to_i == 200
    end
  end
  
  module Upfile
    def image?
      ["image/jpeg", "image/tiff", "image/png", "image/gif", "image/bmp"].include?(content_type)
    end
  end
end