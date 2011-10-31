@seedling_path = File.expand_path(File.join(File.dirname(__FILE__), 'seedlings'))

def model_count_before_and_after(model, &block)
  return unless model
  total = model.count
  block.call
  new_count = model.count
  number_added = (total - new_count).abs
  plural_model = model.table_name.humanize
  if number_added == 0
    puts "No new #{plural_model} loaded"
  else
    puts "Added #{number_added} new #{plural_model}; there are now #{new_count} #{plural_model}"
  end
end

# == Set up Menu Item Keywords
model_count_before_and_after(OtmKeyword) do
  rows = FasterCSV.read((@seedling_path + '/menu_item_keywords.csv'), :headers => true)
  rows.each do |row|
    row.each do |field|
      unless field[1].nil?
        keyword = OtmKeyword.find_or_initialize_by_name_and_category(field[1], field[0])
        keyword.save!
      end
    end
  end
end

# == Set up Promotion Types ==
# model_count_before_and_after(PromotionType) do
#   promotion_types = YAML.load_file(@seedling_path + '/promotion_types.yml')['promotion_types']
#   promotion_types.each do |promotion_types|
#     PromotionType.find_or_create_by_name(promotion_types)
#   end
# end

# == Set up Regions ==
# model_count_before_and_after(JamesBeardRegion) do
#   regions = {
#     "Great Lakes" => "IL, IN, MI, OH", 
#     "Mid-Atlantic" => "D.C., DE, MD, NJ, PA, VA", 
#     "Midwest" => "IA, KS, MN, MO, NE, ND, SD, WI", 
#     "New York City" => "Five Boroughs", 
#     "Northeast" => "CT, MA, ME, NH, NY State, RI, VT", 
#     "Northwest" => "AK, ID, MT, OR, WA, WY", 
#     "Pacific" => "CA, HI", 
#     "South" => "AL, AR, FL, LA, MS", 
#     "Southeast" => "GA, KY, NC, SC, TN, WV", 
#     "Southwest" =>  "AZ, CO, NM, NV, OK, TX, UT"
#   }
# 
#   regions.each_pair do |region_name, desc|
#     region = JamesBeardRegion.find_by_name(region_name)
#     region ||= JamesBeardRegion.create!(:name => region_name, :description => desc)
#   end
# end
# 
# # == Set up Media Request Types ==
# model_count_before_and_after(MediaRequestType) do
#   request_types = YAML.load_file(@seedling_path + '/media_request_types.yml')
#   request_types.each_pair do |shortname, name_and_fields|
#     name = name_and_fields['name']
#     fields = name_and_fields['fields']
#     fields = fields.join(", ") if fields
#     rt = MediaRequestType.find_by_shortname(shortname)
#     rt ||= MediaRequestType.create!(:shortname => shortname, :name => name, :fields => fields)
#   end
# end
# 
# 
# # == Set up Cuisines ==
# model_count_before_and_after(Cuisine) do
#   cuisines = YAML.load_file(@seedling_path + '/cuisines.yml')['cuisines']
#   cuisines.each do |c|
#     Cuisine.find_or_create_by_name(c)
#   end
# end
# 
# # == Set up Specialties ==
# model_count_before_and_after(Specialty) do
#   specialties = YAML.load_file(@seedling_path + '/specialties.yml')['specialties']
#   specialties.each do |s|
#     Specialty.find_or_create_by_name(s)
#   end
# end

# == Set up Metropolitan Regions ==
# model_count_before_and_after(MetropolitanArea) do
#   metroareas = YAML.load_file(@seedling_path + '/metroregions.yml')['metroregions']
#   metroareas.each do |ma|
#     next if MetropolitanArea.find_by_name(ma['name'])
#     MetropolitanArea.create!(ma)
#   end
# end

# == Set up Restaurant Roles ==
# model_count_before_and_after(RestaurantRole) do
#   roles = YAML.load_file(@seedling_path + '/restaurant_roles.yml')['restaurant_roles']
#   roles.each do |role|
#     RestaurantRole.find_or_create_by_name(role)
#   end
# end

# == Set up Subject Matters ==
# model_count_before_and_after(SubjectMatter) do
#   subject_matters = YAML.load_file(@seedling_path + '/subject_matters.yml')['subject_matters']
#   subject_matters.each do |subject_matter|
#     SubjectMatter.find_or_create_by_name(subject_matter)
#   end
# end

# == Set up Culinary Schools ==
# model_count_before_and_after(School) do
#   culinary_schools = YAML.load_file(@seedling_path + '/culinary_schools.yml')['culinary_schools']
#   culinary_schools.each do |school|
#     next if School.find_by_name(school['name'])
#     school['country'] ||= "United States"
#     School.create!(school)
#   end
# end

# model_count_before_and_after(RestaurantFeature) do
# #  RestaurantFeaturePage.delete_all
# #  RestaurantFeatureCategory.delete_all
# #  RestaurantFeature.delete_all
#   pages = {
#       "Cuisine" => ["Accoutrement", "Cheese", "Cuisine style", "Cuisine tag", "Cuisine",
#           "Cuisine type", "Meals served", "Menu change", "Menu structure",
#           "Physical menu construction"],
#       "Beverage" => ["Alcohol service", "Cocktails and beers", "Coffee-tea",
#           "Non-alcoholic beverages", "Wine"],
#       "Design" => ["Artwork", "Atmosphere", "Decor style", "Decor",
#           "Decorative elements", "Seating types", "Space history"],
#       "Other" => ["Activities", "Dress code", "Hours of operation",
#           "Kids' activities", "Outdoor dining", "Parking", "Payment",
#           "Reservations", "Retail area", "Signature products", "Smoking",
#           "Takeout"],
#   }
# 
#   pages.each do |key, values|
#     page = RestaurantFeaturePage.find_or_create_by_name(key)
#     values.each do |value|
#       category = RestaurantFeatureCategory.find_or_create_by_name(value)
#       category.update_attributes(:restaurant_feature_page => page)
#     end
#   end
# 
#   Dir.glob(@seedling_path + '/restaurant_features/*.txt').each do |filename|
#     category_name = File.basename(filename, ".txt").gsub(/options|tags|lookup|dropdown|tag/, "").humanize.strip
#     category = RestaurantFeatureCategory.find_by_name(category_name)
#     raise "Oops #{category_name}" unless category
#     values = File.read(filename).split("\r")
#     values.each do |value|
#       feature = RestaurantFeature.find_or_create_by_value(value.strip)
#       feature.update_attributes(:restaurant_feature_category => category)
#     end
#   end
# end