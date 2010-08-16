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
  belongs_to :user
  validates_uniqueness_of :user_id
  has_many :extended_profile_items

  # BEGIN 'dynamic' associations
  CATEGORIES = %w(experience awards education associations)
  cattr_accessor :dynamic_associations
  @@dynamic_associations = []

  CATEGORIES.each do |category|
    has_many "#{category}_items".to_sym, :conditions => {:category => category}, :class_name => 'ExtendedProfileItem'
    accepts_nested_attributes_for "#{category}_items".to_sym,
                                  :reject_if =>  lambda { |a| a[:content].blank? },
                                  :allow_destroy => true
    @@dynamic_associations << "#{category}_items"
  end
  # END 'dynamic' associations

  def build_extended_items
    for association in @@dynamic_associations
      self.send(association).build
    end
  end
end
