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

  named_scope :from_premium_subjects, lambda {
    { :joins => 'INNER JOIN subscriptions ON `subscriptions`.subscriber_id = responder_id AND `subscriptions`.subscriber_type = responder_type',
      :conditions => ['`subscriptions`.id IS NOT NULL AND (`subscriptions`.end_date IS NULL OR `subscriptions`.end_date >= ?)',
          Date.today]}
  }

end
