@seedling_path = File.expand_path(File.join(File.dirname(__FILE__), 'seedlings'))

# == Set up Regions ==
regions = {"Great Lakes" => "IL, IN, MI, OH", "Mid-Atlantic" => "D.C., DE, MD, NJ, PA, VA", "Midwest" => "IA, KS, MN, MO, NE, ND, SD, WI", "New York City" => "Five Boroughs", "Northeast" => "CT, MA, ME, NH, NY State, RI, VT", "Northwest" => "AK, ID, MT, OR, WA, WY", "Pacific" => "CA, HI", "South" => "AL, AR, FL, LA, MS", "Southeast" => "GA, KY, NC, SC, TN, WV", "Southwest" =>  "AZ, CO, NM, NV, OK, TX, UT"}

regions.each_pair do |region_name, desc|
  region = JamesBeardRegion.find_by_name(region_name)
  region ||= JamesBeardRegion.create!(:name => region_name, :description => desc)
end

puts "There are now #{JamesBeardRegion.count} regions"

# == Set up Media Request Types ==

request_types = YAML.load_file(@seedling_path + '/media_request_types.yml')

request_types.each_pair do |shortname, name_and_fields|
  name = name_and_fields['name']
  fields = name_and_fields['fields']
  fields = fields.join(", ") if fields
  rt = MediaRequestType.find_by_shortname(shortname)
  rt ||= MediaRequestType.create!(:shortname => shortname, :name => name, :fields => fields)
end

puts "There are now #{MediaRequestType.count} media request types"


# == Set up Cuisines ==

cuisines = YAML.load_file(@seedling_path + '/cuisines.yml')['cuisines']

cuisines.each do |c|
  Cuisine.find_or_create_by_name(c)
end

puts "There are now #{Cuisine.count} cuisines"


# == Set up Metropolitan Regions ==

metroareas = YAML.load_file(@seedling_path + '/metroregions.yml')['metroregions']
metroareas.each do |ma|
  MetropolitanArea.find_or_create_by_name(ma)
end

puts "There are now #{MetropolitanArea.count} metropolitan areas"


# == Set up Restaurant Roles ==

roles = YAML.load_file(@seedling_path + '/restaurant_roles.yml')['restaurant_roles']
roles.each do |role|
  RestaurantRole.find_or_create_by_name(role)
end

puts "There are now #{RestaurantRole.count} restaurant roles"






