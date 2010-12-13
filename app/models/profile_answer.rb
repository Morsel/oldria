# == Schema Information
# Schema version: 20100913210123
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
  include ActionController::UrlWriter

  belongs_to :profile_question
  belongs_to :user
  
  validates_presence_of :answer, :profile_question_id, :user_id
  validates_uniqueness_of :profile_question_id, :scope => :user_id

  attr_accessor :post_to_facebook, :share_url
  after_save    :post_to_facebook
  
  named_scope :from_premium_users, lambda {
    { :joins => { :user => :subscription },
      :conditions => ["subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
          Date.today]}
  }

  def post_to_facebook
    post = { :message => self.profile_question.title.to_s + " - " + self.answer.to_s,
             :caption => self.user.name + ":: Behind The Line :: Topic: Background",
             :link    => @share_url }
    response = self.user.facebook_user.feed_create(Mogli::Post.new(:message => post[:message],
                                                                   :link    => post[:link],
                                                                   :caption => post[:caption])) if @post_to_facebook.to_s == "1"
  end
end
