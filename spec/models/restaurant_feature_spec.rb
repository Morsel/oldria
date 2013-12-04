require_relative '../spec_helper'

describe RestaurantFeature do

  let(:decor) { RestaurantFeaturePage.create!(:name => "Decor") }
  let(:type) { RestaurantFeatureCategory.create!(:name => "Type", :restaurant_feature_page => decor) }
  let(:open) { RestaurantFeature.create!(:value => "Open", :restaurant_feature_category => type) }


  it "has breadcrumbs" do
    open.breadcrumbs.should == "Decor : Type : Open"
  end

  describe "deletable" do

    let(:feature) { RestaurantFeature.create(:value => "Feature") }

    specify { feature.should be_deletable }

    it "should not be deletable if it has tags" do
      feature.restaurants << Factory(:restaurant)
      feature.should_not be_deletable
    end

  end

end
