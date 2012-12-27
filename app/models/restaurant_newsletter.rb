class RestaurantNewsletter < ActiveRecord::Base

  belongs_to :restaurant
  serialize :menu_item_ids
  serialize :restaurant_answer_ids
  serialize :menu_ids
  serialize :promotion_ids
  serialize :a_la_minute_answer_ids

  def self.create_with_content(restaurant_id)
    restaurant = Restaurant.find(restaurant_id)
    newsletter = create(:menu_item_ids => restaurant.menu_items.all(:order => "created_at DESC", :limit => 5, :select => "id"),
      :restaurant_answer_ids => restaurant.restaurant_answers.all(:order => "created_at DESC", :limit => 5, :select => "id"),
      :menu_ids => restaurant.menus.all(:order => "updated_at DESC", :limit => 5, :select => "id"),
      :promotion_ids => restaurant.promotions.all(:order => "created_at DESC", :limit => 5, :select => "id"),
      :a_la_minute_answer_ids => restaurant.a_la_minute_answers.all(:order => "created_at DESC", :limit => 5, :select => "id"),
      :restaurant => restaurant)
  end

  def menu_items
    MenuItem.find(menu_item_ids)
  end

  def restaurant_answers
    RestaurantAnswer.find(restaurant_answer_ids)
  end

  def menus
    Menu.find(menu_ids)
  end

  def promotions
    Promotion.find(promotion_ids)
  end

  def a_la_minute_answers
    ALaMinuteAnswer.find(a_la_minute_answer_ids)
  end

end
