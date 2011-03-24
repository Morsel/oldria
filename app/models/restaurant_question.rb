# == Schema Information
# Schema version: 20110323232407
#
# Table name: restaurant_questions
#
#  id                :integer         not null, primary key
#  title             :string(255)
#  position          :integer
#  chapter_id        :integer
#  pages_description :text
#  created_at        :datetime
#  updated_at        :datetime
#

class RestaurantQuestion < ActiveRecord::Base

  belongs_to :chapter
  has_many :question_pages, :dependent => :destroy
  has_many :profile_answers, :dependent => :destroy

  validates_presence_of :title, :chapter_id
  validates_uniqueness_of :title, :scope => :chapter_id, :case_sensitive => false

  named_scope :for_page, lambda { |page| {
    :joins => :question_pages,
    :conditions => { :question_pages => { :restaurant_feature_page_id => page.id }}
    :include => :chapter,
    :order => "chapters.position, restaurant_questions.position" }
  }
  
  named_scope :for_chapter, lambda { |chapter_id|
    { :conditions => { :chapter_id => chapter_id } }
  }

  before_save :update_pages_description

  def topic
    chapter.topic
  end

  private
  
  def update_pages_description
    self.roles_description = self.question_pages.map(&:name).to_sentence
  end

end
