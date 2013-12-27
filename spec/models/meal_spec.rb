require_relative '../spec_helper'

describe Meal do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:day) }
  it { should validate_presence_of(:open_at_hours) }
  it { should validate_presence_of(:open_at_minutes) }
  it { should validate_presence_of(:open_at_am_pm) }
  it { should validate_presence_of(:closed_at_hours) }
  it { should validate_presence_of(:closed_at_minutes) }
  it { should validate_presence_of(:closed_at_am_pm) }

  it do
    should ensure_inclusion_of(:day).
      in_array ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
  end

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:meal)
  end

  it "should create a new instance given valid attributes" do
    Meal.create!(@valid_attributes)
  end
 
  describe "#open_at" do
    meal = FactoryGirl.create(:meal)
    meal.open_at.should == "#{ meal.open_at_hours}:#{meal.open_at_minutes}#{meal.open_at_am_pm}"
  end
 
  describe "#closed_at" do
    meal = FactoryGirl.create(:meal)
    meal.closed_at.should == "#{ meal.closed_at_hours}:#{meal.closed_at_minutes}#{meal.closed_at_am_pm}"
  end


end	

