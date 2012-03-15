# == Schema Information
# Schema version: 20120217190417
#
# Table name: profile_answers
#
#  id                  :integer         not null, primary key
#  profile_question_id :integer
#  answer              :text
#  created_at          :datetime
#  updated_at          :datetime
#  user_id             :integer
#

class ProfileAnswer < ActiveRecord::Base

  belongs_to :profile_question
  belongs_to :user

  validates_presence_of :answer, :profile_question_id, :user_id
  validates_uniqueness_of :profile_question_id, :scope => :user_id
  validates_length_of :answer, :maximum => 2000

  attr_accessor :post_to_facebook, :share_url
  after_save    :crosspost

  named_scope :from_premium_users, {
    :joins => { :user => :subscription },
    :conditions => ["subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
      Date.today]
  }

  named_scope :from_public_users, {
    :joins => "INNER JOIN preferences ON `profile_answers`.user_id = `preferences`.owner_id",
    :conditions => ["`preferences`.owner_type = 'User' AND `preferences`.name = 'publish_profile' AND (`preferences`.value IS NULL OR `preferences`.value = ?)", true]
  }

  named_scope :from_premium_and_public_users, {
    :joins => "INNER JOIN preferences ON `profile_answers`.user_id = `preferences`.owner_id
               INNER JOIN subscriptions ON `profile_answers`.user_id = `subscriptions`.subscriber_id",
    :conditions => ["`preferences`.owner_type = 'User' AND `preferences`.name = 'publish_profile' AND `preferences`.value = ?
                    AND subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
                    true, Date.today]
  }

  named_scope :recently_answered, :order => "profile_answers.created_at DESC"

  named_scope :without_travel, :joins => { :profile_question => { :chapter => :topic }},
      :conditions => ["topics.title != ?", "Travel Guide"]

  named_scope :for_topic, lambda { |topic|
    { :joins => { :profile_question => { :chapter => :topic } },
      :conditions => ["topics.id = ?", topic.id] }
  }

  def question
    profile_question.title
  end

  def chapter_id
    profile_question.chapter.id
  end

  def activity_name
    "Behind the Line"
  end

  private

  def crosspost
    if post_to_facebook == "1"
      name = self.user.respond_to?(:name) ? self.user.name : ""
      post = { :message => self.profile_question.title.to_s + " - " + self.answer.to_s,
               :caption => name + ":: Behind The Line :: Topic: Background",
               :link    => @share_url }
      self.user.send_later(:post_to_facebook, post)
    end
  end

end
