@seedling_path = File.expand_path(File.join(File.dirname(__FILE__), 'seedlings'))

def model_count_before_and_after(model, &block)
  return unless model
  total = model.count
  block.call
  new_count = model.count
  number_added = total - new_count
  plural_model = model.table_name.humanize
  if number_added == 0
    puts "No new #{plural_model} loaded"
  else
    puts "Added #{number_added} new #{plural_model}; there are now #{new_count} #{plural_model}"
  end
end

# == Set up Regions ==
model_count_before_and_after(JamesBeardRegion) do
  regions = {"Great Lakes" => "IL, IN, MI, OH", "Mid-Atlantic" => "D.C., DE, MD, NJ, PA, VA", "Midwest" => "IA, KS, MN, MO, NE, ND, SD, WI", "New York City" => "Five Boroughs", "Northeast" => "CT, MA, ME, NH, NY State, RI, VT", "Northwest" => "AK, ID, MT, OR, WA, WY", "Pacific" => "CA, HI", "South" => "AL, AR, FL, LA, MS", "Southeast" => "GA, KY, NC, SC, TN, WV", "Southwest" =>  "AZ, CO, NM, NV, OK, TX, UT"}

  regions.each_pair do |region_name, desc|
    region = JamesBeardRegion.find_by_name(region_name)
    region ||= JamesBeardRegion.create!(:name => region_name, :description => desc)
  end
end

# == Set up Media Request Types ==
model_count_before_and_after(MediaRequestType) do
  request_types = YAML.load_file(@seedling_path + '/media_request_types.yml')
  request_types.each_pair do |shortname, name_and_fields|
    name = name_and_fields['name']
    fields = name_and_fields['fields']
    fields = fields.join(", ") if fields
    rt = MediaRequestType.find_by_shortname(shortname)
    rt ||= MediaRequestType.create!(:shortname => shortname, :name => name, :fields => fields)
  end
end


# == Set up Cuisines ==
model_count_before_and_after(Cuisine) do
  cuisines = YAML.load_file(@seedling_path + '/cuisines.yml')['cuisines']
  cuisines.each do |c|
    Cuisine.find_or_create_by_name(c)
  end
end

# == Set up Metropolitan Regions ==
model_count_before_and_after(MetropolitanArea) do
  metroareas = YAML.load_file(@seedling_path + '/metroregions.yml')['metroregions']
  metroareas.each do |ma|
    MetropolitanArea.find_or_create_by_name(ma)
  end
end

# == Set up Restaurant Roles ==
model_count_before_and_after(RestaurantRole) do
  roles = YAML.load_file(@seedling_path + '/restaurant_roles.yml')['restaurant_roles']
  roles.each do |role|
    RestaurantRole.find_or_create_by_name(role)
  end
end

# == Set up Subject Matters ==
model_count_before_and_after(SubjectMatter) do
  subject_matters = YAML.load_file(@seedling_path + '/subject_matters.yml')['subject_matters']
  subject_matters.each do |subject_matter|
    SubjectMatter.find_or_create_by_name(subject_matter)
  end
end

# == Set up Culinary Schools ==
model_count_before_and_after(CulinarySchool) do
  culinary_schools = YAML.load_file(@seedling_path + '/culinary_schools.yml')['culinary_schools']
  culinary_schools.each do |culinary_school|
    next if CulinarySchool.find_by_name(culinary_school['name'])
    culinary_school['country'] ||= "United States"
    CulinarySchool.create!(culinary_school)
  end
end
