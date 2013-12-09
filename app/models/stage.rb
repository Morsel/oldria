# == Schema Information
# Schema version: 20120217190417
#
# Table name: stages
#
#  id            :integer         not null, primary key
#  establishment :string(255)
#  expert        :string(255)
#  start_date    :date
#  end_date      :date
#  comments      :text
#  profile_id    :integer
#  created_at    :datetime
#  updated_at    :datetime
#  location      :string(255)
#

class Stage < ActiveRecord::Base
  
  belongs_to :profile
  
  validates_presence_of :establishment, :expert, :start_date, :profile_id
  validate :end_date_after_start_date
  attr_accessible :establishment, :expert, :start_date, :end_date, :location, :comments,:profile

  def end_date_after_start_date
    if end_date.present? && end_date.to_date < start_date.to_date
      errors.add(:end_date, "must come after the date started")
      false
    end
  end
end
