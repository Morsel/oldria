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
end
