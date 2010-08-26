# == Schema Information
# Schema version: 20100825200638
#
# Table name: topics
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  position   :integer
#

class Topic < ActiveRecord::Base

  has_many :chapters
  has_many :profile_questions, :through => :chapters
  has_and_belongs_to_many :question_roles

  validates_presence_of :title, :question_roles
  
  default_scope :order => "topics.title ASC"
  
  def question_roles_description
    question_roles.map(&:name).to_sentence
  end
  
  def title_with_roles
    "[#{question_roles_description}] #{title}"
  end
  
  # for formtastic
  alias :to_label :title_with_roles

end
