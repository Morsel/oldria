module Restaurants::BehindTheLineHelper

  def restaurant_btl_title(restaurant, page)
    if page.present?
      "#{restaurant.name} - #{page.name}"
    else
      restaurant.name
    end
  end

end
