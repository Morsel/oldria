class Profile < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :user_id
  has_many :extended_profile_items
end
