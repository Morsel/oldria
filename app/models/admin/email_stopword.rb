# == Schema Information
#
# Table name: email_stopwords
#
#  id         :integer         not null, primary key
#  phrase     :text
#  created_at :datetime
#  updated_at :datetime
#

class Admin::EmailStopword < ActiveRecord::Base

  validates_presence_of :phrase
  attr_accessible :phrase


end
