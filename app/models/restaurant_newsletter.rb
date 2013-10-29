class RestaurantNewsletter < ActiveRecord::Base
  attr_accessible :menu_item_ids, :restaurant_answer_ids, :menu_ids, :promotion_ids, :a_la_minute_answer_ids, :restaurant, :introduction,:subject,:campaign_id
  belongs_to :restaurant
  serialize :menu_item_ids
  serialize :restaurant_answer_ids
  serialize :menu_ids
  serialize :promotion_ids
  serialize :a_la_minute_answer_ids

  def self.create_with_content(restaurant_id)
    restaurant = Restaurant.find(restaurant_id)
    
    if restaurant.restaurant_newsletters.blank?
      filter_date = 7.day.ago
    else
      filter_date = restaurant.restaurant_newsletters.find(:all,:order => "created_at desc").first.created_at
    end

    newsletter = create(:menu_item_ids => restaurant.menu_items.all(:order => "created_at DESC", :limit => 7, :select => "id",:conditions => ["created_at > ? ",filter_date]),
    :restaurant_answer_ids => restaurant.restaurant_answers.all(:order => "created_at DESC", :limit => 7, :select => "id",:conditions => ["created_at > ? ",filter_date]),
    :menu_ids => restaurant.menus.all(:order => "updated_at DESC", :limit => 7, :select => "id",:conditions => ["created_at > ? ",filter_date]),
    :promotion_ids => restaurant.promotions.all(:order => "created_at DESC", :limit => 7, :select => "id",:conditions => ["created_at > ? ",filter_date]),
    :a_la_minute_answer_ids => restaurant.a_la_minute_answers.all(:order => "created_at DESC", :limit => 7, :select => "id",:conditions => ["created_at > ? ",filter_date]),
    :restaurant => restaurant,:introduction => restaurant.newsletter_setting.try(:introduction))
  end

  def menu_items
    MenuItem.find(:all,:conditions=>["id in(?)",menu_item_ids])
  end

  def restaurant_answers
    RestaurantAnswer.find(:all,:conditions=>["id in(?)",restaurant_answer_ids])
  end

  def menus
    Menu.find(:all,:conditions=>["id in(?)",menu_ids])
  end

  def promotions
    Promotion.find(:all,:conditions=>["id in(?)",promotion_ids])
  end

  def a_la_minute_answers
    ALaMinuteAnswer.find(:all,:conditions=>["id in(?)",a_la_minute_answer_ids])
  end

end
