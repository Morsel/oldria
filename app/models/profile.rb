# == Schema Information
# Schema version: 20100805194513
#
# Table name: profiles
#
#  id         :integer         not null, primary key
#  user_id    :integer         not null
#  birthday   :date
#  job_start  :date
#  cellnumber :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Profile < ActiveRecord::Base
  REJECT_ALL_BLANK_PROC = proc { |attributes| attributes.all? { |_, value| value.blank? } }
  REJECT_TITLE_BLANK_PROC = proc { |attributes| attributes['title'].blank? }

  belongs_to :user
  validates_uniqueness_of :user_id
  has_many :culinary_jobs
  has_many :nonculinary_jobs

  accepts_nested_attributes_for :culinary_jobs, :reject_if => REJECT_TITLE_BLANK_PROC
  accepts_nested_attributes_for :nonculinary_jobs, :reject_if => REJECT_TITLE_BLANK_PROC


  def primary_employment
    user.primary_employment
  end

  def primary_employment=(ids)
    unless user.primary_employment && (user.primary_employment.id == ids.first.to_i)
      user.primary_employment.update_attribute(:primary, false)
      Employment.find(ids).first.update_attribute(:primary, true)
    end
  end

end
