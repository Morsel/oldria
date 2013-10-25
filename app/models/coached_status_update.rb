# == Schema Information
#
# Table name: coached_status_updates
#
#  id            :integer         not null, primary key
#  message       :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  date_range_id :integer
#

class CoachedStatusUpdate < ActiveRecord::Base
  belongs_to :date_range

  scope :current, lambda { |*args| {:joins => :date_range, :conditions => ["date_ranges.start_date < ? AND date_ranges.end_date > ?", Date.today, Date.today]} }
  scope :random, :order => RANDOM_SQL_STRING
  attr_accessible :message,:date_range_id


  def self.seasons
    @@seasons ||= %w{Winter Spring Summer Fall}
  end

  def self.holidays
    @@holidays ||= %w{Christmas Hannukah Thanksgiving Labor_Day}.map {|s| s.gsub(/_/, ' ')}
  end
end
