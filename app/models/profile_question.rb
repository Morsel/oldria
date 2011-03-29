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
  has_many :question_roles, :dependent => :destroy
  has_many :restaurant_roles, :through => :question_roles
  has_many :profile_answers, :dependent => :destroy

  validates_presence_of :title, :chapter_id
  validates_uniqueness_of :title, :scope => :chapter_id, :case_sensitive => false

  named_scope :for_user, lambda { |user|
    { :joins => :question_roles,
      :include => :chapter,
      :conditions => ["question_roles.restaurant_role_id = ?", user.primary_employment.restaurant_role.id],
      :order => "chapters.position, profile_questions.position" }
  }

  named_scope :for_chapter, lambda { |chapter_id|
    { :conditions => { :chapter_id => chapter_id } }
  }

  named_scope :answered, :joins => :profile_answers

  named_scope :answered_for_user, lambda { |user|
    { :joins => :profile_answers,
      :conditions => ["profile_answers.user_id = ?", user.id],
      :order => "chapters.position, profile_questions.position" }
  }

  named_scope :answered_for_chapter, lambda { |chapter_id|
    { :joins => [:chapter, :profile_answers], :conditions => ["chapters.id = ?", chapter_id] }
  }

  named_scope :answered_by_premium_users, lambda {
    { :joins => { :profile_answers => { :user => :subscription }},
      :conditions => ["subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
          Date.today] }
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
    self.profile_answers.select { |a| a.user == user }.first
  end

  def find_or_build_answer_for(user)
    answer = self.answered_by?(user) ?
      self.answer_for(user) : 
      self.profile_answers.build(:user => user)
  end

  protected

  def update_roles_description
    self.roles_description = self.question_roles.map(&:restaurant_role).map(&:name).to_sentence
  end

end

