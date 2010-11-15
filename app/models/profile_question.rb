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
  # has_many :responders, :through => :question_roles
  has_many :profile_answers

  validates_presence_of :title, :chapter_id
  validates_uniqueness_of :title, :scope => :chapter_id, :case_sensitive => false

  named_scope :for_user, lambda { |user|
    { :joins => :question_roles,
      :conditions => ["question_roles.responder_id = ? AND question_roles.responder_type = ?", user.primary_employment.restaurant_role.id, user.primary_employment.restaurant_role.class.name],
    :include => :chapter,
    :order => "chapters.position, profile_questions.position" }
  }

  named_scope :for_chapter, lambda { |chapter_id|
    { :conditions => { :chapter_id => chapter_id } }
  }

  named_scope :answered, :joins => :profile_answers

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

  def responders=(responder_ids)
    responder_ids = responder_ids.select { |id| id.present? }
    responder_type = self.chapter.topic.responder_type
    responders = if responder_type == 'restaurant'
      RestaurantFeaturePage.find(responder_ids.compact)
    else
      RestaurantRole.find(responder_ids.compact)
    end
    responders.collect do |responder|
      self.question_roles.build(:responder => responder)
    end
  end

  def responders
    self.question_roles.collect(&:responder)
  end

  protected

  def update_roles_description
    self.roles_description = self.responders.map(&:name).to_sentence
  end

end

