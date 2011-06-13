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
    { :joins => [:profile_answers, :question_roles],
      :include => :chapter,
      :conditions => ["profile_answers.user_id = ? AND question_roles.restaurant_role_id = ?",
                      user.id, user.primary_employment.restaurant_role.id],
      :order => "chapters.position, profile_questions.position" }
  }

  named_scope :answered_for_chapter, lambda { |chapter_id|
    { :joins => [:chapter, :profile_answers],
      :conditions => ["chapters.id = ?", chapter_id] }
  }

  named_scope :answered_by_premium_users, lambda {
    { :joins => { :profile_answers => { :user => :subscription }},
      :conditions => ["subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
          Date.today] }
  }

  named_scope :random, :order => RANDOM_SQL_STRING
  named_scope :recently_answered, :include => :profile_answers, :order => "profile_answers.created_at DESC"
  named_scope :without_travel, :joins => { :chapter => :topic }, :conditions => ["topics.title != ?", "Travel Guide"]

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

  def latest_answer
    profile_answers.first(:order => "created_at DESC")
  end

  def soapbox_answer_count
    profile_answers.from_premium_users.select { |a| a.user.try(:prefers_publish_profile?) }.count
  end

  def users_with_answers
    profile_answers.map(&:user).uniq
  end

  def users_without_answers
    ids = self.profile_answers.map(&:user_id)
    if ids.present?
      self.restaurant_roles.map { |r| r.employees.all(:conditions => ["users.id NOT IN (?)", ids]) }.flatten.uniq
    else
      self.restaurant_roles.map { |r| r.employees.all }.flatten.uniq
    end
  end

  def email_title
    "Behind the Line"
  end

  def short_title
    "btl"
  end

  def email_body
    title
  end

  # Send an email to everyone who hasn't responded but could
  def notify_users!
    for user in users_without_answers
      UserMailer.deliver_answerable_message_notification(self, user)
    end
  end

  def create_response_for_user(user, answer)
    self.profile_answers.create(:user => user, :answer => answer)
  end

  protected

  def update_roles_description
    self.roles_description = self.question_roles.map(&:restaurant_role).map(&:name).to_sentence
  end

end

