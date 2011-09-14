# == Schema Information
# Schema version: 20110913204942
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
  has_many :restaurant_feature_pages, :through => :question_pages
  has_many :restaurant_answers, :dependent => :destroy

  validates_presence_of :title, :chapter_id
  validates_uniqueness_of :title, :scope => :chapter_id, :case_sensitive => false

  named_scope :for_page, lambda { |page|
    { :joins => :question_pages,
      :include => :chapter,
      :conditions => { :question_pages => { :restaurant_feature_page_id => page.id }},
      :order => "chapters.position, restaurant_questions.position"
    }
  }

  named_scope :for_chapter, lambda { |chapter_id|
    { :conditions => { :chapter_id => chapter_id } }
  }

  named_scope :answered, :joins => :restaurant_answers

  named_scope :answered_for_restaurant, lambda { |restaurant|
    { :joins => :restaurant_answers,
      :conditions => ['restaurant_answers.restaurant_id = ?', restaurant.id]
    }
  }

  named_scope :answered_for_page, lambda { |page, restaurant|
    { :joins => [:restaurant_answers, :question_pages],
      :conditions => ['restaurant_answers.restaurant_id = ? AND question_pages.restaurant_feature_page_id = ?',
        restaurant.id, page.id]
    }
  }

  named_scope :answered_for_chapter, lambda { |chapter_id|
    { :joins => [:chapter, :restaurant_answers], 
      :conditions => ["chapters.id = ?", chapter_id]
    }
  }

  named_scope :answered_by_premium_restaurants, lambda {
    { :joins => "INNER JOIN restaurant_answers ON restaurant_answers.restaurant_question_id = restaurant_questions.id
        INNER JOIN subscriptions ON subscriptions.subscriber_id = restaurant_answers.restaurant_id AND subscriptions.subscriber_type = `restaurant`",
      :conditions => ["subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)", Date.today]
    }
  }

  before_save :update_pages_description

  def topic
    chapter.topic
  end

  def answered_by?(restaurant)
    self.restaurant_answers.exists?(:restaurant_id => restaurant.id)
  end

  def answer_for(restaurant)
    self.restaurant_answers.select { |a| a.restaurant == restaurant }.first
  end

  def find_or_build_answer_for(restaurant)
    answer = self.answered_by?(restaurant) ?
      self.answer_for(restaurant) : 
      self.restaurant_answers.build(:restaurant => restaurant)
  end

  private
  
  def update_pages_description
    self.pages_description = self.question_pages.map(&:restaurant_feature_page).map(&:name).to_sentence
  end

end
