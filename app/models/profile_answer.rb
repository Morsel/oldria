# == Schema Information
# Schema version: 20101207221226
#
# Table name: profile_answers
#
#  id                  :integer         not null, primary key
#  profile_question_id :integer
#  answer              :text
#  created_at          :datetime
#  updated_at          :datetime
#  responder_id        :integer
#  responder_type      :string(255)
#

class ProfileAnswer < ActiveRecord::Base

  belongs_to :profile_question
  belongs_to :responder, :polymorphic => true

  validates_presence_of :answer, :profile_question_id, :responder_id, :responder_type
  validates_uniqueness_of :profile_question_id, :scope => [:responder_id, :responder_type]

  attr_accessor :post_to_facebook, :share_url
  after_save    :post_to_facebook

  named_scope :from_premium_subjects, lambda {
    { :joins => 'INNER JOIN subscriptions ON `subscriptions`.subscriber_id = responder_id AND `subscriptions`.subscriber_type = responder_type',
      :conditions => ['`subscriptions`.id IS NOT NULL AND (`subscriptions`.end_date IS NULL OR `subscriptions`.end_date >= ?)',
          Date.today]}
  }

  def post_to_facebook
    name = self.responder.respond_to?(:name) ? self.responder.name : ""
    post = { :message => self.profile_question.title.to_s + " - " + self.answer.to_s,
             :caption => name + ":: Behind The Line :: Topic: Background",
             :link    => @share_url }
    response = self.responder.facebook_user.feed_create(Mogli::Post.new(:message => post[:message],
                                                                        :link    => post[:link],
                                                                        :caption => post[:caption])) if @post_to_facebook.to_s == "1"
  end
end
