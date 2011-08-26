class SiteActivityObserver < ActiveRecord::Observer
  
  observe Menu, Photo
  
  def after_save(record)
    SiteActivity.create!(:description => "Saved #{record.class.to_s.downcase} for #{record.restaurant.name}")
  end
  
end
