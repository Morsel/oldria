module RestaurantsHelper
  def restaurant_link(restaurant, options = nil)
    if (params[:controller].match(/soapbox/) || params[:controller].match(/mediafeed/))
      if restaurant.premium_account?
        link_to(h(restaurant.name), soapbox_restaurant_path(restaurant), options) 
      else
        h(restaurant.name)
      end
    else
      link_to(h(restaurant.name), restaurant_path(restaurant), options)
    end
  end

  def restaurant_names_for_user(user)
    if user.employments.blank?
      user.primary_employment.try(:solo_restaurant_name)
    elsif user.employments.count == 1
      restaurant_link(user.primary_employment.restaurant)
    else
      user.employments.all(:order => '"primary" DESC', :include => :restaurant).map{|e| restaurant_link(e.restaurant) }.to_sentence
    end
  end
  
  def correct_restaurant_photos_path restaurant
     soapbox? ? soapbox_restaurant_photos_path(restaurant) : restaurant_photos_path(restaurant)
  end
end
