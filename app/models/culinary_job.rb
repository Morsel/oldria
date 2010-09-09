# == Schema Information
# Schema version: 20100825200638
#
# Table name: culinary_jobs
#
#  id              :integer         not null, primary key
#  profile_id      :integer         not null
#  restaurant_name :string(255)     default(""), not null
#  title           :string(255)     default(""), not null
#  city            :string(255)     default(""), not null
#  state           :string(255)     default(""), not null
#  country         :string(255)     default(""), not null
#  date_started    :date            not null
#  date_ended      :date
#  chef_name       :string(255)     default(""), not null
#  chef_is_me      :boolean         not null
#  cuisine         :text            default(""), not null
#  notes           :text            default(""), not null
#  created_at      :datetime
#  updated_at      :datetime
#

class CulinaryJob < ActiveRecord::Base
  belongs_to :profile

  validates_presence_of :restaurant_name, :title, :city, :state, :country
  validates_presence_of :date_started, :chef_name, :cuisine
  validate :date_ended_after_date_started

  def date_ended_after_date_started
    if date_ended.present? && date_ended.to_date < date_started.to_date
      errors.add(:date_ended, "must come after the date started")
      false
    end
  end
end
