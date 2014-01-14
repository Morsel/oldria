require_relative '../spec_helper'

describe RestaurantFeaturePage do
  it { should have_many(:restaurant_feature_categories) }
  it { should have_many(:question_pages).dependent(:destroy) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  
  describe "deletable" do

    let(:page) { RestaurantFeaturePage.create(:name => "Page") }

    specify { page.should be_deletable }

    it "should not be deletable if it has categories" do
      page.restaurant_feature_categories << RestaurantFeatureCategory.create(:name => "Cagetory")
      page.should_not be_deletable
    end

  end

  describe ".by_name" do
    it "should return by_name" do
      feature = FactoryGirl.create(:restaurant_feature_page)
      RestaurantFeaturePage.by_name.should == RestaurantFeaturePage.find(:all,:order => 'name ASC')
    end
  end

  describe "#questions" do
    it "should return questions" do
      feature = FactoryGirl.create(:restaurant_feature_page)
      feature.questions(opts = {}).should == RestaurantQuestion.for_page(feature).all(opts)
    end
  end

  describe "#topics" do
    it "should return topics" do
      feature = FactoryGirl.create(:restaurant_feature_page)
      feature.topics.should == RestaurantTopic.for_page(feature)
    end
  end

  describe "#published_topics" do
    it "should return published_topics" do
      feature = FactoryGirl.create(:restaurant_feature_page)
      restaurant = FactoryGirl.create(:restaurant)
      feature.published_topics(restaurant).should == feature.topics.select { |t| t.published?(restaurant, feature) }
    end
  end  

end
