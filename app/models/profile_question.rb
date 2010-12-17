# == Schema Information
# Schema version: 20101026213148
#
# Table name: profile_questions
#
#  id                :integer         not null, primary key
#  title             :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  position          :integer
#  chapter_id        :integer
#  roles_description :text
#

class ProfileQuestion < ActiveRecord::Base

  belongs_to :chapter
  has_many :question_roles
  has_many :restaurant_roles, :through => :question_roles
  has_many :profile_answers

  validates_presence_of :title, :chapter_id, :restaurant_roles
  validates_uniqueness_of :title, :scope => :chapter_id, :case_sensitive => false

  named_scope :for_user, lambda { |user|
    { :joins => :restaurant_roles,
      :conditions => ["restaurant_roles.id = ?", user.primary_employment.restaurant_role.id],
    :include => :chapter,
    :order => "chapters.position, profile_questions.position" }
  }

  named_scope :for_chapter, lambda { |chapter_id|
    { :conditions => { :chapter_id => chapter_id } }
  }

  named_scope :answered, :joins => :profile_answers
  named_scope :answered_by_premium_users, lambda {
    { :joins => { :profile_answers => { :user => :subscription }},
      :conditions => ["subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
          Date.today]}
  }

  named_scope :answered_for_user, lambda { |user|
    { :joins => :profile_answers, :conditions => ["profile_answers.user_id = ?", user.id] }
  }

  named_scope :answered_for_chapter, lambda { |chapter_id|
    { :joins => [:chapter, :profile_answers], :conditions => ["chapters.id = ?", chapter_id] }
  }

  named_scope :random, :order => RANDOM_SQL_STRING

  before_save :update_roles_description

  def topic
    chapter.topic
  end

  def answered_by?(user)
    self.profile_answers.exists?(:user_id => user.id)
  end

  def answer_for(user)
    self.profile_answers.find_by_user_id(user.id)
  end

  def find_or_build_answer_for(user)
    self.answered_by?(user) ?
        self.profile_answers.find_by_user_id(user.id) :
        ProfileAnswer.new(:profile_question_id => self.id, :user_id => user.id)
  end

  protected

  def update_roles_description
    self.roles_description = self.restaurant_roles.map(&:name).to_sentence
  end

end

