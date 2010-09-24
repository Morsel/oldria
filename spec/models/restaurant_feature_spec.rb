require 'spec/spec_helper'

describe RestaurantFeature do

  let(:decor) { RestaurantFeaturePage.create!(:name => "Decor") }
  let(:type) { RestaurantFeatureCategory.create!(:name => "Type", :restaurant_feature_page => decor) }
  let(:open) { RestaurantFeature.create!(:value => "Open", :restaurant_feature_category => type) }


  it "has breadcrumbs" do
    open.breadcrumbs.should == "Decor : Type : Open"
  end

end