module MediafeedHelper
  
  def media_feed_css_class_if_home
    "hp" if request.path == mediafeed_root_path or request.subdomains.include?('mediafeed')
  end
end