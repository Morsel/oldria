# == Schema Information
# Schema version: 20100412193718
#
# Table name: admin_discussions
#
#  id                :integer         not null, primary key
#  restaurant_id     :integer
#  trend_question_id :integer
#  created_at        :datetime
#  updated_at        :datetime
#  comments_count    :integer
#

class AdminDiscussion < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :discussionable, :polymorphic => true
  acts_as_readable
  acts_as_commentable
  validates_uniqueness_of :restaurant_id, :scope => [:discussionable_id, :discussionable_type]


  def message
    [discussionable.subject, discussionable.body].reject(&:blank?).join(": ")
  end

  def inbox_title
    "Trend Question"
  end

  def scheduled_at
    discussionable.scheduled_at
  end

end
