# Set up Regions

regions = {"Great Lakes" => "IL, IN, MI, OH", "Mid-Atlantic" => "D.C., DE, MD, NJ, PA, VA", "Midwest" => "IA, KS, MN, MO, NE, ND, SD, WI", "New York City" => "Five Boroughs", "Northeast" => "CT, MA, ME, NH, NY State, RI, VT", "Northwest" => "AK, ID, MT, OR, WA, WY", "Pacific" => "CA, HI", "South" => "AL, AR, FL, LA, MS", "Southeast" => "GA, KY, NC, SC, TN, WV", "Southwest" =>  "AZ, CO, NM, NV, OK, TX, UT"}

regions.each_pair do |region_name, desc|
  region = JamesBeardRegion.find_by_name(region_name)
  region ||= JamesBeardRegion.create!(:name => region_name, :description => desc)
end

puts "There are now #{JamesBeardRegion.count} regions"

# Set up Media Request Types

request_types = {
  'information' => ["Information Request", ""],
  'photo'       => ["Photo Request", "Photo needed, Photo requirements, Other important notes"],
  'interview'   => ["Interview Scheduling", "By phone or in person?, Convenient date and time 1, Convenient date and time 2, Convenient date and time 3, Interview subject, Are there any requirements for the interview?"], 
  'recipe'      => ["Recipe Request", "Dish or Drink?"],
  'photoshoot'  => ["Photo Shoot/On-Site Video Shoot Scheduling", "For which outlet is this shoot?, Requested Date and Time, Alternate Date and Time, Primary subject, Appearance requirements"]
}

request_types.each_pair do |shortname, name_and_fields|
  name, fields = name_and_fields
  rt = MediaRequestType.find_by_shortname(shortname)
  rt ||= MediaRequestType.create!(:shortname => shortname, :name => name, :fields => fields)
end

puts "There are now #{MediaRequestType.count} media request types"