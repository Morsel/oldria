class SiteActivityObserver < ActiveRecord::Observer
  
  observe Menu
  
  def after_save(record)
    SiteActivity.create!(:description => "Saved menu for #{record.restaurant.name}")
  end
  
end
