module MediafeedHelper
  
  def media_feed_css_class_if_home
    "hp clear clearfix" if @mediafeed_home_page
  end
end