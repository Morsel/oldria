# == Schema Information
# Schema version: 20100903165039
#
# Table name: profiles
#
#  id                :integer         not null, primary key
#  user_id           :integer         not null
#  birthday          :date
#  job_start         :date
#  cellnumber        :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  headline          :string(255)     default("")
#  summary           :text            default("")
#  hometown          :string(255)
#  current_residence :string(255)
#

class Profile < ActiveRecord::Base
  REJECT_ALL_BLANK_PROC = proc { |attributes| attributes.all? { |_, value| value.blank? } }
  REJECT_TITLE_BLANK_PROC = proc { |attributes| attributes['title'].blank? && attributes['name'].blank? }

  validates_uniqueness_of :user_id
  validates_presence_of :hometown, :current_residence
  
  belongs_to :user
  
  has_many :culinary_jobs, :order => "date_started DESC"
  has_many :nonculinary_jobs, :order => "date_started DESC"
  has_many :nonculinary_enrollments
  has_many :nonculinary_schools, :through => :nonculinary_enrollments
  has_many :awards
  has_many :accolades
  has_many :enrollments
  has_many :schools, :through => :enrollments
  has_many :competitions
  has_many :internships
  has_many :stages
  has_many :apprenticeships
  has_many :profile_cuisines
  has_many :cuisines, :through => :profile_cuisines
  has_many :profile_specialties
  has_many :specialties, :through => :profile_specialties

  accepts_nested_attributes_for :culinary_jobs, :nonculinary_jobs, :awards, :user, :specialties,
    :reject_if => REJECT_TITLE_BLANK_PROC
    
  ### Preferences ###
  preference :display_cell, :string, :default => "everyone"
  preference :display_email, :string, :default => "everyone"
  preference :display_twitter, :string, :default => "everyone"
  preference :display_facebook, :string, :default => "everyone"

  def primary_employment
    user.primary_employment
  end

  def primary_employment=(ids)
    unless user.primary_employment && (user.primary_employment.id == ids.first.to_i)
      user.primary_employment.update_attribute(:primary, false)
      Employment.find(ids).first.update_attribute(:primary, true)
    end
  end
  
  def work_experience_updated_at
    timestamps = [user.employments.all(:order => :updated_at).last.try(:updated_at), 
      culinary_jobs.all(:order => :updated_at).last.try(:updated_at), 
      nonculinary_jobs.all(:order => :updated_at).last.try(:updated_at)]
    timestamps.blank? ? timestamps.sort { |a, b| b <=> a }.first : Time.now
  end
  
  def section_updated_at(section)
    section.all(:order => :updated_at).last.try(:updated_at)
  end

end
