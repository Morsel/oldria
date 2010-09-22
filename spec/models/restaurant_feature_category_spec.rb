require 'spec/spec_helper'

describe RestaurantFeatureCategory do

  describe "categories" do

    before(:each) do
      @cuisine = RestaurantFeatureCategory.create!(:name => "Cuisine")
      @decor = RestaurantFeatureCategory.create!(:name => "Decor")
      @american = RestaurantFeature.create!(:category => @cuisine, :value => "American")
      @ugly = RestaurantFeature.create!(:category => @decor, :value => "Ugly")
      @pretty = RestaurantFeature.create!(:category => @decor, :value => "Pretty") 
    end

    it "finds all categories" do
      RestaurantFeatureCategory.by_name.map(&:name).should == %w(Cuisine Decor)
    end

  end

end