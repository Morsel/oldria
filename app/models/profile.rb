# == Schema Information
#
# Table name: profiles
#
#  id                    :integer         not null, primary key
#  user_id               :integer         not null
#  birthday              :date
#  job_start             :date
#  cellnumber            :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  headline              :string(255)     default("")
#  summary               :text            default("")
#  hometown              :string(255)
#  current_residence     :string(255)
#  metropolitan_area_id  :integer
#  james_beard_region_id :integer
#

class Profile < ActiveRecord::Base
  REJECT_ALL_BLANK_PROC = proc { |attributes| attributes.all? { |_, value| value.blank? } }
  REJECT_TITLE_BLANK_PROC = proc { |attributes| attributes['title'].blank? && attributes['name'].blank? }

  belongs_to :user
  
  has_many :culinary_jobs, :order => "date_started DESC"
  has_many :nonculinary_jobs, :order => "date_started DESC"
  has_many :nonculinary_enrollments
  has_many :nonculinary_schools, :through => :nonculinary_enrollments
  has_many :awards
  has_many :accolades, :as => :accoladable
  has_many :enrollments
  has_many :schools, :through => :enrollments
  has_many :competitions
  has_many :internships
  has_many :stages
  has_many :apprenticeships
  has_many :profile_cuisines
  has_many :cookbooks
  has_many :cuisines, :through => :profile_cuisines
  has_many :profile_specialties
  has_many :specialties, :through => :profile_specialties

  belongs_to :metropolitan_area
  belongs_to :james_beard_region

  validates_uniqueness_of :user_id
  validates_presence_of :hometown, :current_residence
  validates_presence_of :metropolitan_area, :james_beard_region
  validate :birthday_year_is_set
  validates_length_of :summary, :maximum => 1000, :allow_blank => true
  accepts_nested_attributes_for :culinary_jobs, :nonculinary_jobs, :awards, :user, :specialties,
    :reject_if => REJECT_TITLE_BLANK_PROC
  
  ### Preferences ###
  preference :display_cell, :string, :default => "everyone"
  preference :display_email, :string, :default => "everyone"
  preference :display_twitter, :string, :default => "everyone"
  preference :display_facebook, :string, :default => "everyone"
  
  [:display_cell, :display_email, :display_twitter, :display_facebook].each do |sym|
    define_method :"#{sym}_public?" do
      send(:"preferred_#{sym}") == "everyone"
    end
  end
  attr_accessible :metropolitan_area_id, :james_beard_region_id, :specialty_ids, 
      :birthday, :job_start, :headline, :summary, :hometown, :current_residence,
      :prefers_display_cell, :cellnumber, :prefers_display_email, :user_attributes,
      :primary_employment
  def primary_employment
    user.primary_employment
  end

  def primary_employment=(ids)
    if user.nil? # no profile created yet
      Employment.find(ids).first.update_attribute(:primary, true)
    else
      # skip if the primary employment hasn't changed
      unless user.primary_employment && (user.primary_employment.id == ids.first.to_i)
        user.primary_employment.update_attribute(:primary, false)
        Employment.find(ids).first.update_attribute(:primary, true)
      end
    end
  end
  
  def work_experience_updated_at
    timestamps = [user.employments.all(:order => :updated_at).last.try(:updated_at), 
      culinary_jobs.all(:order => :updated_at).last.try(:updated_at)]
    timestamps.blank? ? timestamps.sort { |a, b| b <=> a }.first : Time.now
  end
  
  def non_culinary_work_experience_updated_at
    nonculinary_jobs.all(:order => :updated_at).last.try(:updated_at)
  end
  
  def section_updated_at(section)
    section.all(:order => :updated_at).last.try(:updated_at)
  end
  
  def birthday_year_is_set
    self.errors.add(:birthday, "must specify a year") if self.birthday.present? && self.birthday.year == 1
  end

  def culinary_schools
    enrollments
  end

end
