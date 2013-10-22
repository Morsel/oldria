# == Schema Information
# Schema version: 20120217190417
#
# Table name: topics
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  position    :integer
#  description :string(255)
#  type        :string(255)
#

class RestaurantTopic < Topic

  has_many :restaurant_questions, :through => :chapters

  scope :for_restaurant, lambda { |restaurant|
      { :conditions => { :type => 'RestaurantTopic' },
        :select => "distinct topics.*",
        :order => :position }
  }

  scope :for_page, lambda { |page|
    { :joins => { :chapters => { :restaurant_questions => :question_pages }},
      :conditions => ["question_pages.restaurant_feature_page_id = ?", page.id],
      :select => "distinct topics.*",
      :order => :position }
  }

  scope :answered_for_restaurant, lambda { |restaurant|
    { :joins => { :chapters => { :restaurant_questions => :restaurant_answers } },
      :conditions => ["restaurant_answers.restaurant_id = ?", restaurant.id],
      :select => "distinct topics.*",
      :order => :position }
  }

  scope :answered_for_page, lambda { |page, restaurant|
    { :joins => { :restaurant_questions => [:restaurant_answers, :question_pages] },
      :conditions => ["restaurant_answers.restaurant_id = ? AND question_pages.restaurant_feature_page_id = ?",
        restaurant.id, page.id],
      :select => "distinct topics.*",
      :order => :position }
  }

  def previous_for_context(restaurant, page, is_self = false)
    sort_field = (self.position == 0 ? "id" : "position")
    is_self_prefix = is_self ? "answered_" : ""

    if page.present? && is_self
      RestaurantTopic.send("for_page", page).first(
        :conditions => ["topics.#{sort_field} > ?", self.send(sort_field)],
        :order => "#{sort_field} ASC")
    elsif page.present?
      RestaurantTopic.send("answered_for_page", page, restaurant).first(
        :conditions => ["topics.#{sort_field} < ?", self.send(sort_field)],
        :order => "#{sort_field} DESC")
    else
      RestaurantTopic.send("#{is_self_prefix}for_restaurant", restaurant).first(
        :conditions => ["topics.#{sort_field} < ?", self.send(sort_field)],
        :order => "#{sort_field} DESC")
    end
  end

  def next_for_context(restaurant, page, is_self = false)
    sort_field = (self.position == 0 ? "id" : "position")
    is_self_prefix = is_self ? "answered_" : ""

    if page.present? && is_self
      RestaurantTopic.send("for_page", page).first(
        :conditions => ["topics.#{sort_field} > ?", self.send(sort_field)],
        :order => "#{sort_field} ASC")
    elsif page.present?
      RestaurantTopic.send("answered_for_page", page, restaurant).first(
        :conditions => ["topics.#{sort_field} > ?", self.send(sort_field)],
        :order => "#{sort_field} ASC")
    else
      RestaurantTopic.send("#{is_self_prefix}for_restaurant", restaurant).first(
        :conditions => ["topics.#{sort_field} > ?", self.send(sort_field)],
        :order => "#{sort_field} ASC")
    end
  end

  def question_count_for_restaurant(restaurant, page = nil)
    page.present? ? self.restaurant_questions.for_page(page).count : self.restaurant_questions.count
  end
  
  def answer_count_for_restaurant(restaurant, page = nil)
    page.present? ?
        restaurant_questions.answered_for_page(page, restaurant).count :
        restaurant_questions.answered_for_restaurant(restaurant).count
  end
  
  def completion_percentage(restaurant, page = nil)
    if question_count_for_restaurant(restaurant, page) > 0
      ((answer_count_for_restaurant(restaurant, page).to_f / question_count_for_restaurant(restaurant, page).to_f) * 100).to_i
    else
      0
    end
  end
  
  def published?(restaurant, page = nil)
    completion_percentage(restaurant, page) > 0
  end

end
