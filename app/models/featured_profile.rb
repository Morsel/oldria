class FeaturedProfile < ActiveRecord::Base
	belongs_to :feature, :polymorphic => true
	validates_presence_of :feature_id 	, :start_date
	validates_uniqueness_of :feature_id, :scope => :feature_type 	

	named_scope :valid_feature_profiels, lambda {
    { :conditions => "feature_type IS NOT NULL AND feature_id IS NOT NULL" }
  }

  named_scope :spotlight_user, lambda {
    { :conditions => "feature_type = 'User' and spotlight_on = 1 and (end_date IS NULL OR  end_date between '#{Date.today.at_midnight.strftime('%Y-%m-%d %H:%m:%S')}' and '#{Date.today.end_of_day.strftime('%Y-%m-%d %H:%m:%S')}') and start_date < '#{Time.now.strftime('%Y-%m-%d %H:%m:%S')}' " }
  }

  named_scope :spotlight_restaurant, lambda {
    { :conditions => "feature_type = 'Restaurant' and spotlight_on = 1 and (end_date IS NULL OR  end_date between '#{Date.today.at_midnight.strftime('%Y-%m-%d %H:%m:%S')}' and '#{Date.today.end_of_day.strftime('%Y-%m-%d %H:%m:%S')}') and start_date < '#{Time.now.strftime('%Y-%m-%d %H:%m:%S')}' " }
  }

end

