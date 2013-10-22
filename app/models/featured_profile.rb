class FeaturedProfile < ActiveRecord::Base
	belongs_to :feature, :polymorphic => true
	validates_presence_of :feature_id 	, :start_date
	validates_uniqueness_of :feature_id, :scope => :feature_type 	

	scope :valid_feature_profiles, lambda {
    { :conditions => "feature_type IS NOT NULL AND feature_id IS NOT NULL" }
  }

  scope :spotlight_user, lambda {
    { :conditions =>["feature_type = 'User' and spotlight_on = 1 and (end_date IS NULL OR  end_date > DATE(?)) and start_date < DATE(?) ",Time.now,Time.now] }
  }

  scope :personal_profiles, lambda { 
    { :conditions => ["spotlight_on = 1 and (end_date IS NULL OR  end_date > DATE(?) ) and start_date < DATE(?) ",Time.now,Time.now] }
  }


end

