class SiteActivityObserver < ActiveRecord::Observer
  
  observe Menu, Photo, Promotion, MenuItem, ALaMinuteAnswer, RestaurantAnswer, ProfileAnswer, RestaurantFactSheet, Comment
  
  def after_save(record)
    return if record.is_a?(Comment) && !record.track_activity?
    creator = if record.is_a?(Comment)
      record.user
    else
      record.respond_to?(:restaurant) ? record.restaurant : record.user
    end
    SiteActivity.create!(:description => "Saved #{record.activity_name}", :creator => creator, :content => record)
  end
  
end
