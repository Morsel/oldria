# == Schema Information
# Schema version: 20120217190417
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
  attr_accessible :title,:chapter_id,:restaurant_feature_page_ids


  scope :for_page, lambda { |page|
    { :joins => :question_pages,
      :include => :chapter,
      :conditions => { :question_pages => { :restaurant_feature_page_id => page.id }},
      :order => "chapters.position, restaurant_questions.position"
    }
  }

  scope :for_chapter, lambda { |chapter_id|
    { :conditions => { :chapter_id => chapter_id } }
  }

  scope :answered, :joins => :restaurant_answers

  scope :answered_for_restaurant, lambda { |restaurant|
    { :joins => :restaurant_answers,
      :conditions => ['restaurant_answers.restaurant_id = ?', restaurant.id]
    }
  }

  scope :answered_for_page, lambda { |page, restaurant|
    { :joins => [:restaurant_answers, :question_pages],
      :conditions => ['restaurant_answers.restaurant_id = ? AND question_pages.restaurant_feature_page_id = ?',
        restaurant.id, page.id]
    }
  }

  scope :answered_for_chapter, lambda { |chapter_id|
    { :joins => [:chapter, :restaurant_answers], 
      :conditions => ["chapters.id = ?", chapter_id]
    }
  }

  scope :answered_by_premium_restaurants, lambda {
    { :joins => { :restaurant_answers => { :restaurant => :subscription }},
      :conditions => ["subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
          Date.today] }
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

  def latest_soapbox_answer
    restaurant_answers.from_premium_restaurants.first(:order => "created_at DESC")
  end
   # Send an email to everyone who hasn't responded but could
  def notify_users!    
    for user in restaurant_user_without_answers
      unless user.nil? # TODO Identify why giving NoMethodError: undefined method `cloudmail_id' for nil:NilClass
        UserMailer.deliver_answerable_message_notification(self, user)
      end  
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

  def restaurant_user_without_answers
    ids = self.restaurant_answers.map(&:restaurant_id)    
    if ids.present?
      Restaurant.all.map { |r| r.manager unless ids.include?(r.id) }.flatten.uniq #r.managers.all(:conditions => ["restaurants.id NOT IN (?)", ids]) 
    else
      Restaurant.all.map { |r| r.manager }.flatten.uniq
    end
  end
  private
  
  def update_pages_description
    self.pages_description = self.question_pages.map(&:restaurant_feature_page).map(&:name).to_sentence
  end

  

end
