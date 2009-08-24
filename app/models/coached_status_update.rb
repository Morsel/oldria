class CoachedStatusUpdate < ActiveRecord::Base
  belongs_to :date_range
  def self.seasons
    @@seasons ||= %w{Winter Spring Summer Fall}
  end
  
  def self.holidays
    @@holidays ||= %w{Christmas Hannukah Thanksgiving Labor_Day}.map {|s| s.gsub(/_/, ' ')}
  end
end
