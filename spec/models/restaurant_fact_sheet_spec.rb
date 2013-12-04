require_relative '../spec_helper'

describe RestaurantFactSheet do
  let(:fact_sheet) { RestaurantFactSheet.new }

  %w{ dinner_average_price dinner_average_price lunch_average_price brunch_average_price breakfast_average_price children_average_price small_plate_min_price small_plate_max_price large_plate_min_price large_plate_max_price dessert_plate_min_price dessert_plate_max_price wine_by_the_glass_min_price wine_by_the_glass_max_price wine_by_the_bottle_min_price wine_by_the_bottle_max_price }.each do |field|
    it "validates format of #{field}" do
      fact_sheet.send("#{field}=", "xyz")
      fact_sheet.save
      fact_sheet.should have(1).error_on(field.to_sym)

      fact_sheet.send("#{field}=", "10.00")
      fact_sheet.save
      fact_sheet.should have(:no).error_on(field.to_sym)
    end
  end

  [["small_plate_min_price", "small_plate_max_price"], ["large_plate_min_price", "large_plate_max_price"], ["dessert_plate_min_price", "dessert_plate_max_price"], ["wine_by_the_glass_min_price", "wine_by_the_glass_max_price"], ["wine_by_the_bottle_min_price", "wine_by_the_bottle_max_price"]].each do |min, max|
    it "validates presence of #{min} and #{max} together" do
      fact_sheet.save
      fact_sheet.should have(:no).error_on(min.to_sym)
      fact_sheet.should have(:no).error_on(max.to_sym)

      fact_sheet.send "#{min}=", "10"
      fact_sheet.send "#{max}=", nil
      fact_sheet.save
      fact_sheet.should have(:no).error_on(min.to_sym)
      fact_sheet.should have(1).error_on(max.to_sym)

      fact_sheet.send "#{min}=", nil
      fact_sheet.send "#{max}=", "10"
      fact_sheet.save
      fact_sheet.should have(1).error_on(min.to_sym)
      fact_sheet.should have(:no).error_on(max.to_sym)

      fact_sheet.send "#{min}=", "5"
      fact_sheet.send "#{max}=", "10"
      fact_sheet.save
      fact_sheet.should have(:no).error_on(min.to_sym)
      fact_sheet.should have(:no).error_on(max.to_sym)
    end
  end

  ["wine_by_the_glass_count", "wine_by_the_bottle_count", "square_footage"].each do |field|
    it "validates numericality of #{field} as integers" do
      fact_sheet.send "#{field}=", "xyz"
      fact_sheet.save
      fact_sheet.should have(1).error_on(field.to_sym)

      fact_sheet.send "#{field}=", "5"
      fact_sheet.save
      fact_sheet.should have(:no).error_on(field.to_sym)
    end
  end
end

