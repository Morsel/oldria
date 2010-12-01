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

  named_scope :for_subject, lambda { |subject|
    if subject.is_a? User
      { :joins => :question_roles,
        :conditions => ["question_roles.responder_id = ? AND question_roles.responder_type = ?", subject.primary_employment.restaurant_role.id, subject.primary_employment.restaurant_role.class.name],
        :include => :chapter,
        :order => "chapters.position, profile_questions.position" }
    elsif subject.is_a? RestaurantFeaturePage
      { :joins => :question_roles,
        :conditions => ["question_roles.responder_id = ? AND question_roles.responder_type = ?", subject.id, subject.class.name],
        :include => :chapter,
        :order => "chapters.position, profile_questions.position" }
    elsif subject.is_a? Restaurant
      { :joins => { :chapter => :topic },
        :conditions => ["topics.responder_type = ?", 'restaurant'],
        :include => :chapter,
        :order => "chapters.position, profile_questions.position" }
    end
  }

  named_scope :for_chapter, lambda { |chapter_id|
    { :conditions => { :chapter_id => chapter_id } }
  }

  named_scope :answered, :joins => :profile_answers

  named_scope :answered_for_subject, lambda { |subject|
    { :joins => :profile_answers, :conditions => ["profile_answers.responder_id = ? AND profile_answers.responder_type = ?", subject.id, subject.class.name] }
  }

  named_scope :answered_for_page, lambda { |page, restaurant|
    { :joins => [:profile_answers, :question_roles],
      :conditions => ["profile_answers.responder_id = ? AND profile_answers.responder_type = ? AND question_roles.responder_id = ? AND question_roles.responder_type = ?", restaurant.id, restaurant.class.name, page.id, page.class.name] }
  }

  named_scope :answered_for_chapter, lambda { |chapter_id|
    { :joins => [:chapter, :profile_answers], :conditions => ["chapters.id = ?", chapter_id] }
  }

  named_scope :random, :order => RANDOM_SQL_STRING

  before_save :update_roles_description

  def topic
    chapter.topic
  end

  def answered_by?(subject)
    self.profile_answers.exists?(:responder_id => subject.id, :responder_type => subject.class.name)
  end

  def answer_for(subject)
    self.profile_answers.select { |a| a.responder == subject }.first
  end

  def find_or_build_answer_for(subject)
    answer = self.answered_by?(subject) ?
        self.answer_for(subject) : self.profile_answers.build(:responder => subject)
  end

  def responders=(responder_ids)
    responder_ids = responder_ids.select { |id| id.present? }
    responder_type = self.chapter.topic.responder_type
    responders = if responder_type == 'restaurant'
      RestaurantFeaturePage.find(responder_ids.compact)
    else
      RestaurantRole.find(responder_ids.compact)
    end
    self.question_roles = responders.collect do |responder|
      self.question_roles.build(:responder => responder)
    end
  end

  def responders
    self.question_roles.collect(&:responder).collect(&:id)
  end

  protected

  def update_roles_description
    self.roles_description = self.question_roles.collect(&:responder).map(&:name).to_sentence
  end

end

