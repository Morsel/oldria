regions = {"Great Lakes" => "IL, IN, MI, OH", "Mid-Atlantic" => "D.C., DE, MD, NJ, PA, VA", "Midwest" => "IA, KS, MN, MO, NE, ND, SD, WI", "New York City" => "Five Boroughs", "Northeast" => "CT, MA, ME, NH, NY State, RI, VT", "Northwest" => "AK, ID, MT, OR, WA, WY", "Pacific" => "CA, HI", "South" => "AL, AR, FL, LA, MS", "Southeast" => "GA, KY, NC, SC, TN, WV", "Southwest" =>  "AZ, CO, NM, NV, OK, TX, UT"}

regions.each_pair do |region_name, desc|
  region = JamesBeardRegion.find_by_name(region_name)
  region ||= JamesBeardRegion.create!(:name => region_name, :description => desc)
end

puts "There are now #{JamesBeardRegion.count} regions"

