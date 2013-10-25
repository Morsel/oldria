# == Schema Information
# Schema version: 20120217190417
#
# Table name: restaurant_feature_pages
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class RestaurantFeaturePage < ActiveRecord::Base
  has_many :restaurant_feature_categories
  has_many :question_pages, :dependent => :destroy
  has_many :profile_questions, :through => :question_roles

  validates_presence_of :name
  validates_uniqueness_of :name

  scope :by_name, :order => "name ASC"
  attr_accessible :name


  def deletable?
    restaurant_feature_categories.empty?
  end

  # Behind the line

  def questions(opts = {})
    RestaurantQuestion.for_page(self).all(opts)
  end

  def topics
    RestaurantTopic.for_page(self)
  end

  def published_topics(restaurant)
    topics.select { |t| t.published?(restaurant, self) }
  end

end
