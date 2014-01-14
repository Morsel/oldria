require_relative '../spec_helper'

describe RestaurantFeature do
  it { should belong_to(:restaurant_feature_category) }
  it { should have_many(:restaurant_feature_items).dependent(:destroy) }
  it { should have_many(:restaurants).through(:restaurant_feature_items) }
  #it { should have_many(:trace_searches) }
  it { should validate_presence_of(:value) }
  it { should validate_uniqueness_of(:value).scoped_to(:restaurant_feature_category_id) }

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
      feature.restaurants << FactoryGirl.create(:restaurant)
      feature.should_not be_deletable
    end

  end

  describe "#restaurant_feature_page" do
    it "should return restaurant_feature_page" do
      feature = FactoryGirl.create(:restaurant_feature)
      feature.restaurant_feature_page.should == feature.restaurant_feature_category.restaurant_feature_page
    end
  end

  describe "#breadcrumbs" do
    it "should return breadcrumbs" do
      feature = FactoryGirl.create(:restaurant_feature)
      feature.breadcrumbs.should == "#{feature.restaurant_feature_page.name} : #{feature.restaurant_feature_category.name} : #{feature.value}"
    end
  end

  describe "#name" do
    it "should return name" do
      feature = FactoryGirl.create(:restaurant_feature)
      feature.name.should == feature.value
    end
  end

  describe "#deletable?" do
    it "should return deletable?" do
      feature = FactoryGirl.create(:restaurant_feature)
      feature.deletable?.should == feature.restaurants.empty?
    end
  end

  describe "#top_tag?" do
    it "should return top_tag?" do
      feature = FactoryGirl.create(:restaurant_feature)
      restaurant = FactoryGirl.create(:restaurant)
      feature.top_tag?(restaurant).should == feature.restaurant_feature_items.find_by_restaurant_id(restaurant.id).top_tag
    end
  end  

end 