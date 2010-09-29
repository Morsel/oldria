Given /^there are the following invitations:$/ do |table|
  table.hashes.each do |hash|
    restaurant_name = hash.delete('restaurant_name')
    restaurant = Restaurant.find_by_name(restaurant_name)
    if restaurant
      Factory(:invitation, hash.merge(:restaurant_id => restaurant.id))
    else
      Factory(:invitation, hash)
    end
  end
end
