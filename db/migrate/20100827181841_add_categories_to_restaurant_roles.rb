#encoding: utf-8 
class AddCategoriesToRestaurantRoles < ActiveRecord::Migration
  def self.up
    add_column :restaurant_roles, :category, :string
    category_hash = {
      "Chef Assistant" => "Culinary",
      "Chef de Cuisine" => "Culinary",
      "Executive Chef" => "Culinary",
      "Executive Chef/Owner" => "Culinary",
      "Executive Sous Chef" => "Culinary",
      "Line Cook" => "Culinary",
      "Pastry Chef" => "Culinary",
      "Pastry Staff" => "Culinary",
      "Sous Chef" => "Culinary",
      "Bar Chef" => "Beverage",
      "Bar Director" => "Beverage",
      "Bartender" => "Beverage",
      "Beverage Director" => "Beverage",
      "Brewer" => "Beverage",
      "Head Brewer" => "Beverage",
      "Mixologist" => "Beverage",
      "Sommelier" => "Beverage",
      "Wine Director" => "Beverage",
      "Wine Director/Owner" => "Beverage",
      "Assistant" => "Management",
      "Assistant Manager" => "Management",
      "Brunch Manager" => "Management",
      "Day Manager" => "Management",
      "General Manager" => "Management",
      "Lunch Manager" => "Management",
      "Manager" => "Management",
      "Operations Director" => "Management",
      "Owner" => "Management",
      "Partner" => "Management",
      "Assistant Event Director" => "Events and Marketing",
      "Event Director" => "Events and Marketing",
      "Marketing Director" => "Events and Marketing",
      "Media Marketing Director" => "Events and Marketing",
      "Private Event Director" => "Events and Marketing",
      "Public Relations Manager" => "Events and Marketing",
      "Traffic Manager" => "Events and Marketing",
      "Head Server" => "Front of the House Staff",
      "Host" => "Front of the House Staff",
      "Maitre d’" => "Front of the House Staff",
      "Server" => "Front of the House Staff",
      "Other" => "Other",
      "RIA Admin" => "Other",
      "RIA Guest" => "Other",
    }
    
    category_hash.each_pair do |k,v|
      role = RestaurantRole.find_by_name(k)
      role.update_attribute(:category, v) if role
    end
  end

  def self.down
    remove_column :restaurant_roles, :category
  end
end
