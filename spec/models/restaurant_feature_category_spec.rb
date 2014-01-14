require_relative '../spec_helper'

describe RestaurantFeatureCategory do
 it { should have_many(:restaurant_features).order('value asc') }
 it { should belong_to(:restaurant_feature_page) }
 it { should validate_presence_of(:name) }
 it { should validate_uniqueness_of(:name) }

  describe "categories" do

    before(:each) do
      @cuisine = RestaurantFeatureCategory.create!(:name => "Cuisine")
      @decor = RestaurantFeatureCategory.create!(:name => "Decor")
      @american = RestaurantFeature.create!(:restaurant_feature_category => @cuisine, :value => "American")
      @ugly = RestaurantFeature.create!(:restaurant_feature_category => @decor, :value => "Ugly")
      @pretty = RestaurantFeature.create!(:restaurant_feature_category => @decor, :value => "Pretty") 
    end

    it "finds all categories" do
      RestaurantFeatureCategory.by_name.map(&:name).should == %w(Cuisine Decor)
    end

  end

  describe "deletable" do

    let(:category) { RestaurantFeatureCategory.create(:name => "Category") }

    specify { category.should be_deletable }

    it "should not be deletable if it has tags" do
      category.restaurant_features << RestaurantFeature.create(:value => "Feature")
      category.should_not be_deletable
    end

  end



end
