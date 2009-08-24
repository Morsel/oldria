class CoachedStatusUpdate < ActiveRecord::Base
  belongs_to :date_range

  named_scope :current, lambda { |*args| {:include => :date_range, :conditions => ["date_ranges.start_date < ? AND date_ranges.end_date > ?", Date.today, Date.today]} }


  def self.seasons
    @@seasons ||= %w{Winter Spring Summer Fall}
  end
  
  def self.holidays
    @@holidays ||= %w{Christmas Hannukah Thanksgiving Labor_Day}.map {|s| s.gsub(/_/, ' ')}
  end
end
