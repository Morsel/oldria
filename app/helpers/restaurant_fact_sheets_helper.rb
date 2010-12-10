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

  def link_to_add_fields(name, f, association, options = {})
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    options.merge!({:"data-association" => association, :"data-fields" => fields})
    link_to(name, '#', options)
  end

  private
  def options_for(list)
    list.collect do |option|
      [option.capitalize, option]
    end
  end
end
