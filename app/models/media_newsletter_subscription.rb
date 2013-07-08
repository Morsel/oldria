class MediaNewsletterSubscription < ActiveRecord::Base
  belongs_to :restaurant 
  belongs_to :media_newsletter_subscriber, :class_name => "User"  ,:foreign_key => "media_newsletter_subscriber_id"
  after_create :add_subscription_to_mailchimp


  def send_newsletters_to_media
    for user in User.find(:all,:conditions=>["role = 'media'"])
      if user.media_newsletter_setting.blank?  
        user.build_media_newsletter_setting.save
      end
      user.send_later(:send_newsletter_to_media_subscribers,user) if !user.media_newsletter_setting.opt_out 
    end
  end


  def self.menu_items(restaurants)
    #menu_items = MenuItem.find_by_sql("SELECT GROUP_CONCAT(result_view.item SEPARATOR ',') as menu_ids FROM  (SELECT  SUBSTRING_INDEX(GROUP_CONCAT( DISTINCT  `id` SEPARATOR ',' ) ,',',3) as item FROM `menu_items` GROUP BY `restaurant_id` HAVING  `restaurant_id` IN (#{restaurants.join(',')}) ORDER BY  `created_at` DESC) result_view").first.menu_ids
    #MenuItem.find(menu_items.split(",")) unless menu_items.nil? # TODO Need to workon this Query
    menu_items = []
    restaurants.each do |restaurant|      
      menu_items.push(restaurant.menu_items.all(:order=>"created_at desc" ,:limit=>3))
    end      
    menu_items.flatten.compact
  end

  def self.menus(restaurants)
    menus = []
    restaurants.each do |restaurant|      
      menus.push(restaurant.menus.all(:order=>"created_at desc" ,:limit=>3))
    end          
    menus.flatten.compact
  end 
  
  def self.restaurant_answers(restaurants)
    restaurant_answers = []
    restaurants.each do |restaurant|      
      restaurant_answers.push(restaurant.a_la_minute_answers.all(:order=>"created_at desc" ,:limit=>3))
    end      
    restaurant_answers.flatten.compact
  end

  def self.promotions(restaurants)
   promotions = []
    restaurants.each do |restaurant|      
      promotions.push(restaurant.promotions.all(:order=>"created_at desc" ,:limit=>3))
    end      
    promotions.flatten.compact
  end

  private

  def add_subscription_to_mailchimp      
    media_newsletter_subscriber.digest_mailchimp_update
  end
end
