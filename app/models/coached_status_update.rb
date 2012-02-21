# == Schema Information
# Schema version: 20120217190417
#
# Table name: coached_status_updates
#
#  id            :integer         not null, primary key
#  message       :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  date_range_id :integer
#
# Indexes
#
#  index_coached_status_updates_on_date_range_id  (date_range_id)
#

class CoachedStatusUpdate < ActiveRecord::Base
  belongs_to :date_range

  named_scope :current, lambda { |*args| {:joins => :date_range, :conditions => ["date_ranges.start_date < ? AND date_ranges.end_date > ?", Date.today, Date.today]} }
  named_scope :random, :order => RANDOM_SQL_STRING


  def self.seasons
    @@seasons ||= %w{Winter Spring Summer Fall}
  end

  def self.holidays
    @@holidays ||= %w{Christmas Hannukah Thanksgiving Labor_Day}.map {|s| s.gsub(/_/, ' ')}
  end
end
