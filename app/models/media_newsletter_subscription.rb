class MediaNewsletterSubscription < ActiveRecord::Base
  belongs_to :restaurant 
  belongs_to :media_newsletter_subscriber, :class_name => "User"  ,:foreign_key => "media_newsletter_subscriber_id"
  #after_create :add_subscription_to_mailchimp
  attr_accessible :media_newsletter_subscriber, :restaurant

  def send_newsletters_to_media
    for user in User.find(:all,:conditions=>["role = 'media'"])
      if user.media_newsletter_setting.blank?  
        user.build_media_newsletter_setting.save
      end
      arrMedia=[]    
      arrMedia.push(user.media_newsletter_subscriptions.map(&:restaurant))
      arrMedia.push(user.get_digest_subscription)
      arrMedia.flatten!
      unless MediaNewsletterSubscription.menu_items(arrMedia).blank? && MediaNewsletterSubscription.promotions(arrMedia).blank?

        user.send_later(:send_newsletter_to_media_subscribers,user) if (!user.media_newsletter_setting.opt_out) && (!["Sun","Sat"].include?(Date::ABBR_DAYNAMES[Date.today.wday]))

       end
    end
  end

  def self.menu_items(restaurants)
    #menu_items = MenuItem.find_by_sql("SELECT GROUP_CONCAT(result_view.item SEPARATOR ',') as menu_ids FROM  (SELECT  SUBSTRING_INDEX(GROUP_CONCAT( DISTINCT  `id` SEPARATOR ',' ) ,',',3) as item FROM `menu_items` GROUP BY `restaurant_id` HAVING  `restaurant_id` IN (#{restaurants.join(',')}) ORDER BY  `created_at` DESC) result_view").first.menu_ids
    #MenuItem.find(menu_items.split(",")) unless menu_items.nil? # TODO Need to workon this Query
    menu_items = []
    menu_items = MenuItem.find(:all,:conditions=>["restaurant_id in (?) and (created_at >= ? OR updated_at >= ?) ",restaurants.compact.map(&:id),get_limit_day.day.ago.beginning_of_day,get_limit_day.day.ago.beginning_of_day],:order=>"updated_at desc",:limit=>3)      
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
    promotions = Promotion.find(:all,:conditions=>["restaurant_id in (?) and (created_at >= ? OR updated_at >= ?) ",restaurants.compact.map(&:id),get_limit_day.day.ago.beginning_of_day,get_limit_day.day.ago.beginning_of_day],:order=>"updated_at desc",:limit=>3)      
    promotions.flatten.compact
    
  end

  def self.newsletter_menus(restaurants)
    menus = []
    menus = Menu.find(:all,:conditions=>["restaurant_id in (?) and (created_at >= ? OR updated_at >= ?) ",restaurants.map(&:id),1.day.ago.beginning_of_day,1.day.ago.beginning_of_day],:order=>"updated_at desc",:limit=>3) 
    menus.flatten.compact
  end

  def self.fact_sheets(restaurants)
    fact_sheets = []
    fact_sheets = RestaurantFactSheet.find(:all,:conditions=>["restaurant_id in (?) and (created_at >= ? OR updated_at >= ?) ",restaurants.map(&:id),1.day.ago.beginning_of_day,1.day.ago.beginning_of_day],:order=>"updated_at desc",:limit=>3) 
    fact_sheets.flatten.compact
  end

  def self.photos(restaurants)
    photos = []
    restaurants.each do |restaurant|  
      photos.push(restaurant.photos.find(:all,:conditions=>["(created_at >= ? OR updated_at >= ?) ",1.day.ago.beginning_of_day,1.day.ago.beginning_of_day],:order=>"updated_at desc",:limit=>3))
    end      
    photos.flatten.compact
   
  end

   

  private

  def self.get_limit_day
    if Date::ABBR_DAYNAMES[Date.today.wday] == "Mon"
      return 2
    else
      return 1  
    end 
  end  
  def add_subscription_to_mailchimp      
    media_newsletter_subscriber.digest_mailchimp_update
  end
end
