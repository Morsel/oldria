require_relative '../spec_helper'

describe RestaurantFeaturePage do

  describe "deletable" do

    let(:page) { RestaurantFeaturePage.create(:name => "Page") }

    specify { page.should be_deletable }

    it "should not be deletable if it has categories" do
      page.restaurant_feature_categories << RestaurantFeatureCategory.create(:name => "Cagetory")
      page.should_not be_deletable
    end

  end

end
