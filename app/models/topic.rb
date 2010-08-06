# == Schema Information
# Schema version: 20100802191740
#
# Table name: topics
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Topic < ActiveRecord::Base

  has_many :chapters
  has_many :profile_questions, :through => :chapters

  validates_presence_of :title

  default_scope :order => "topics.title ASC"

end
