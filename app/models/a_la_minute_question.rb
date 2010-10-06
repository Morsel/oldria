class ALaMinuteQuestion < ActiveRecord::Base

  named_scope :restaurants, :conditions => {:kind => :restaurant}

end
