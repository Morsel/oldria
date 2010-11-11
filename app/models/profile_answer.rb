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

  belongs_to :profile_question
  belongs_to :user
  
  validates_presence_of :answer, :profile_question_id, :user_id
  validates_uniqueness_of :profile_question_id, :scope => :user_id
  
  named_scope :from_premium_users, lambda {
    {:include => {:user => :subscription},
     :conditions => ["subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
          Date.today]}
  }

end
