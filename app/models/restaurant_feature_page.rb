class RestaurantFeaturePage < ActiveRecord::Base
  has_many :restaurant_feature_categories
  has_many :question_roles, :as => :responder, :dependent => :destroy
  has_many :profile_questions, :through => :question_roles

  validates_presence_of :name
  validates_uniqueness_of :name

  named_scope :by_name, :order => "name ASC"

  def deletable?
    restaurant_feature_categories.empty?
  end

  # Behind the line

  def profile_questions
    ProfileQuestion.for_subject(self)
  end

  def topics
    Topic.for_subject(self) || []
  end

  def published_topics(secondary_subject = nil)
    topics.select { |t| t.published?(self, secondary_subject) }
  end

end
# == Schema Information
#
# Table name: restaurant_feature_pages
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

