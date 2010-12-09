module RestaurantFactSheetsHelper
  def parking_options
    options_for(RestaurantFactSheet::PARKING_OPTIONS)
  end

  def reservation_options
    options_for(RestaurantFactSheet::RESERVATIONS_OPTIONS)
  end

  def smoking_options
    options_for(RestaurantFactSheet::SMOKING_OPTIONS)
  end

  def price(val)
    "$#{h(val)}"
  end
  def price_range(min, max)
    "#{price(min)} to #{price(max)}"
  end

  private
  def options_for(list)
    list.collect do |option|
      [option.capitalize, option]
    end
  end
end
