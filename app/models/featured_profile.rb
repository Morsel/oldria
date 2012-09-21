class FeaturedProfile < ActiveRecord::Base
	belongs_to :feature, :polymorphic => true
	validates_presence_of :feature_id 	, :start_date
	validates_uniqueness_of :feature_id, :scope => :feature_type 	

	named_scope :valid_feature_profiles, lambda {
    { :conditions => "feature_type IS NOT NULL AND feature_id IS NOT NULL" }
  }

  named_scope :spotlight_user, lambda {
    { :conditions => "feature_type = 'User' and spotlight_on = 1 and (end_date IS NULL OR  end_date > DATE('#{Time.now}')) and start_date < DATE('#{Time.now}') " }
  }

  named_scope :personal_profiles, lambda { 
    { :conditions => " (end_date IS NULL OR  end_date > DATE('#{Time.now}'))  and start_date < DATE('#{Time.now}')" }
  }


end

