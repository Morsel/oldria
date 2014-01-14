require_relative '../spec_helper'

describe RestaurantFactSheet do
  let(:fact_sheet) { RestaurantFactSheet.new }
  it { should belong_to(:restaurant) }
  it { should have_many(:seating_areas).dependent(:destroy) }
  it { should have_many(:tasting_menus).dependent(:destroy) }  
  it { should have_many(:meals).dependent(:destroy) }
  it { should accept_nested_attributes_for(:seating_areas).allow_destroy(true) }
  it { should accept_nested_attributes_for(:tasting_menus).allow_destroy(true) }
  it { should accept_nested_attributes_for(:meals).allow_destroy(true) }
  it { should ensure_inclusion_of(:parking).in_array(["garage", "valet", "street", "lot"]).with_message('extension %s is not included in the list').allow_blank(true).allow_nil(true)}
  it { should ensure_inclusion_of(:reservations).in_array(["accepted", "not accepted", "required", "recommended"]).with_message('extension %s is not included in the list').allow_blank(true).allow_nil(true)}
  it { should ensure_inclusion_of(:smoking).in_array(["not allowed", "outdoors only", "lounge only", "bar only", "hookahs"]).with_message('extension %s is not included in the list').allow_blank(true).allow_nil(true)}
  it { should ensure_inclusion_of(:concept).in_array(["bar", "casual", "casual chef-driven", "chef driven", "counter-service",
                     "fast casual", "fast food", "fine dining", "food truck", "formal dining",
                     "neighborhood dining", "quick service", "self-serve", "takeout only", "retail"]).with_message('extension %s is not included in the list').allow_blank(true).allow_nil(true)} 
  it { should_not allow_value('/^\d+??(?:\.\d{0,2})?$/').for(:dinner_average_price) }  
  it { should_not allow_value('/^\d+??(?:\.\d{0,2})?$/').for(:lunch_average_price) } 
  it { should_not allow_value('/^\d+??(?:\.\d{0,2})?$/').for(:brunch_average_price) }  
  it { should_not allow_value('/^\d+??(?:\.\d{0,2})?$/').for(:breakfast_average_price) } 
  it { should_not allow_value('/^\d+??(?:\.\d{0,2})?$/').for(:small_plate_min_price) }  
  it { should_not allow_value('/^\d+??(?:\.\d{0,2})?$/').for(:small_plate_max_price) } 
  it { should_not allow_value('/^\d+??(?:\.\d{0,2})?$/').for(:large_plate_min_price) }  
  it { should_not allow_value('/^\d+??(?:\.\d{0,2})?$/').for(:large_plate_max_price) } 
  it { should_not allow_value('/^\d+??(?:\.\d{0,2})?$/').for(:dessert_plate_min_price) }  
  it { should_not allow_value('/^\d+??(?:\.\d{0,2})?$/').for(:dessert_plate_max_price) } 
  it { should_not allow_value('/^\d+??(?:\.\d{0,2})?$/').for(:small_plate_min_price) }  
  it { should_not allow_value('/^\d+??(?:\.\d{0,2})?$/').for(:children_average_price) } 
  it { should_not allow_value('/^\d+??(?:\.\d{0,2})?$/').for(:wine_by_the_glass_min_price) } 
  it { should_not allow_value('/^\d+??(?:\.\d{0,2})?$/').for(:wine_by_the_glass_max_price) }  
  it { should_not allow_value('/^\d+??(?:\.\d{0,2})?$/').for(:wine_by_the_bottle_min_price) } 
  it { should_not allow_value('/^\d+??(?:\.\d{0,2})?$/').for(:wine_by_the_bottle_max_price) }  

  describe "#design_section_updated_at" do
    it "should return the design_section_updated_at" do
      restaurant_fact_sheet = FactoryGirl.create(:restaurant_fact_sheet)
      restaurant_fact_sheet.design_section_updated_at.should == [restaurant_fact_sheet.design_updated_at, restaurant_fact_sheet.seating_areas.collect(&:updated_at)].flatten.max
    end
  end   

  describe "#pricing_section_updated_at" do
    it "should return the pricing_section_updated_at" do
      restaurant_fact_sheet = FactoryGirl.create(:restaurant_fact_sheet)
      restaurant_fact_sheet.pricing_section_updated_at.should == [restaurant_fact_sheet.pricing_updated_at, restaurant_fact_sheet.tasting_menus.collect(&:updated_at)].flatten.max
    end
  end   

  describe "#hours_updated_at" do
    it "should return the hours_updated_at" do
      restaurant_fact_sheet = FactoryGirl.create(:restaurant_fact_sheet)
      restaurant_fact_sheet.hours_updated_at.should == restaurant_fact_sheet.meals.collect(&:updated_at).max
    end
  end   

  describe "#entertainments" do
    it "should return the entertainments" do
      restaurant_fact_sheet = FactoryGirl.create(:restaurant_fact_sheet)
      restaurant_fact_sheet.entertainments.should ==  []
    end
  end   

  describe "#activity_name" do
    it "should return the activity_name" do
      restaurant_fact_sheet = FactoryGirl.create(:restaurant_fact_sheet)
      restaurant_fact_sheet.activity_name.should ==  "fact sheet"
    end
  end   

end

