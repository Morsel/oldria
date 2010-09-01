# == Schema Information
# Schema version: 20100826190657
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
#

class Stage < ActiveRecord::Base
  
  belongs_to :profile
  
  validates_presence_of :establishment, :expert, :start_date, :profile_id
  validate :end_date_after_start_date

  def end_date_after_start_date
    if end_date.present? && end_date.to_date < start_date.to_date
      errors.add(:end_date, "must come after the date started")
      false
    end
  end
end
