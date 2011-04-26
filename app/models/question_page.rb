# == Schema Information
# Schema version: 20110323232407
#
# Table name: question_pages
#
#  id                         :integer         not null, primary key
#  restaurant_question_id     :integer
#  restaurant_feature_page_id :integer
#  created_at                 :datetime
#  updated_at                 :datetime
#

class QuestionPage < ActiveRecord::Base

  belongs_to :restaurant_question
  belongs_to :restaurant_feature_page

end
