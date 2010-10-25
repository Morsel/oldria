require 'spec/spec_helper'

describe Restaurant do
  should_belong_to :manager, :class_name => "User"
  should_belong_to :metropolitan_area
  should_belong_to :james_beard_region
  should_belong_to :cuisine
  should_have_many :employments
  should_have_many :employees, :through => :employments
  should_have_many :admin_discussions
  should_have_many :media_request_discussions
  should_have_many :media_requests, :through => :media_request_discussions
  should_have_many :trend_questions, :through => :admin_discussions
  should_have_many :content_requests, :through => :admin_discussions

  describe "manager and employees" do
    it "should belong to a manager (user)" do
      user = Factory(:user)
      restaurant = Factory(:restaurant, :name => "Moon Lodge", :manager => user)
      restaurant.save
      restaurant2 = Restaurant.find(restaurant.id)
      restaurant2.manager.should == user
    end

    it "should add the manager as an employee on create" do
      manager = Factory(:user, :name => "Jim John")
      restaurant = Factory.build(:restaurant, :manager => manager)
      restaurant.employees.should be_empty
      restaurant.save
      restaurant.employees.first.should == manager
    end
  end

  describe "missing_subject_matters" do
    it "should know which subject matters are mising" do
      %w(Beer Other Beverage Food Business Wine Pastry).each do |sm|
        Factory(:subject_matter, :name => sm)
      end

      handled_subject = SubjectMatter.find_by_name("Pastry")

      employment = Factory(:employment, :subject_matters => [handled_subject])
      restaurant = employment.restaurant

      %w(Beer Other Beverage Food Business Wine).each do |sm|
        restaurant.missing_subject_matters.map(&:name).should include(sm)
      end
      restaurant.missing_subject_matters.should_not include(handled_subject)
    end
  end

  describe "safe deletion" do
    it "should not actually delete Restaurants" do
      restaurant = Factory(:restaurant)
      Restaurant.all.should == [restaurant]
      restaurant.destroy
      Restaurant.count.should == 0
      Restaurant.with_destroyed { Restaurant.count }.should == 1
    end

    it "should delete an associated admin_discussion when restaurant is deleted" do
      restaurant = Factory(:restaurant)
      content_request = Factory(:content_request)
      content_request.restaurant_ids = [restaurant.id]
      content_request.admin_discussions.count.should == 1
      restaurant.destroy
      content_request.admin_discussions.count.should == 0
    end

    it "should delete an associated admin_discussion when restaurant is deleted" do
      restaurant = Factory(:restaurant)
      holiday = Factory(:holiday)
      holiday.restaurants = [restaurant]
      holiday_reminder = Factory(:holiday_reminder, :holiday => holiday)
      holiday_reminder.holiday_discussions.count.should == 1
      restaurant.destroy
      holiday_reminder.holiday_discussions.count.should == 0
    end
  end

  describe "media_contact" do
    it "can be assigned a media contact" do
      restaurant = Factory(:restaurant)
      media_contact = Factory(:user)
      restaurant.media_contact = media_contact
      restaurant.save!
      restaurant = Restaurant.find(restaurant.id)
      restaurant.media_contact.should == media_contact
    end
  end

  describe "update features" do

    let(:restaurant) { Factory(:restaurant) }
    let(:features) do
      %w(ugly pretty open closed).map do |value|
        RestaurantFeature.create!(:value => value)
      end
    end

    it "sets feature list from ids" do
      restaurant.reset_features([features[0].id, features[1].id])
      restaurant.restaurant_features.should =~ [features[0], features[1]]
    end

    it "should reset features if features change" do
      restaurant.restaurant_features = [features[1], features[3]]
      restaurant.reset_features([features[0].id])
      restaurant.restaurant_features.should =~ [features[0]]
    end

  end

  describe "feature pages and categories" do

    let(:restaurant) { Factory(:restaurant) }
    let(:decor) { RestaurantFeaturePage.create!(:name => "Decor") }
    let(:cuisine) { RestaurantFeaturePage.create!(:name => "Cuisine") }
    let(:style) { RestaurantFeatureCategory.create!(:name => "Style", :restaurant_feature_page => decor) }
    let(:type) { RestaurantFeatureCategory.create!(:name => "Type", :restaurant_feature_page => decor) }
    let(:meals) { RestaurantFeatureCategory.create!(:name => "Meals", :restaurant_feature_page => cuisine) }
    let(:ugly) { RestaurantFeature.create!(:value => "Ugly", :restaurant_feature_category => style) }
    let(:pretty) { RestaurantFeature.create!(:value => "Pretty", :restaurant_feature_category => style) }
    let(:open) { RestaurantFeature.create!(:value => "Open", :restaurant_feature_category => type) }
    let(:closed) { RestaurantFeature.create!(:value => "Closed", :restaurant_feature_category => type) }
    let(:dinner) { RestaurantFeature.create!(:value => "Dinner", :restaurant_feature_category => meals) }
    let(:brunch) { RestaurantFeature.create!(:value => "Brunch", :restaurant_feature_category => brunch) }

    it "lists its categories" do
      restaurant.restaurant_features = [ugly, pretty, open, closed]
      restaurant.feature_categories.should == [style, type]
      restaurant.feature_pages.should == [decor]
      restaurant.restaurant_features = [ugly, pretty]
      restaurant.feature_categories.should == [style]
      restaurant.feature_pages.should ==  [decor]
    end

    it "finds features by page" do
      restaurant.restaurant_features = [ugly, pretty, dinner]
      restaurant.features_for_page(decor).should == [pretty, ugly]
      restaurant.categories_for_page(decor).should == [style]
      restaurant.features_for_page(cuisine).should == [dinner]
      restaurant.features_for_category(style).should == [pretty, ugly]
    end

    it "finds all restaurants with a tag" do
      restaurant.restaurant_features = [ugly, pretty, dinner]
      r2 = Factory(:restaurant)
      r2.restaurant_features = [pretty, dinner]
      Restaurant.with_feature(ugly).should == [restaurant]
      Restaurant.with_feature(pretty).should =~ [restaurant, r2]
    end
  end

  describe "validate facebook URL" do

    subject { Factory(:restaurant) }
    it { should accept_values_for(:facebook_page, nil, "", "http://www.facebook.com/fred",
        "http://www.facebook.com/profile.php?id=23423",
        "http://www.facebook.com/pages/Random-Restaurant/11746961621") }
    it { should_not accept_values_for(:facebook_page, "fred", "@noelrap",
        "http://www.twitter.com/noelrap") }

  end

  describe "photos" do

    let(:photo_attributes) {{:attachment_content_type => "image/png", :attachment_file_name => "somefile.jpg", :credit => "Joe Pesci"}}

    it "selects the first photo added as the primary photo" do
      restaurant = Factory(:restaurant)
      restaurant.photos.create!(photo_attributes)

      restaurant = Restaurant.find(restaurant.id)
      restaurant.primary_photo.should == restaurant.photos.first
    end

    it "maintains the same primary photo when adding additional photos after the first one" do
      restaurant = Factory(:restaurant)
      restaurant.photos.create!(photo_attributes)
      primary_photo = restaurant.photos.create!(photo_attributes)
      restaurant.photos.create!(photo_attributes)
      restaurant.update_attributes!(:primary_photo => primary_photo)
      restaurant.photos.create!(photo_attributes)

      restaurant = Restaurant.find(restaurant.id)
      restaurant.primary_photo.should == primary_photo
    end

    it "unselects primary photo of restaurant when deleted and it is the only photo for the restaurant" do
      restaurant = Factory(:restaurant)
      primary_photo = restaurant.photos.create!(photo_attributes)
      restaurant.update_attributes!(:primary_photo => primary_photo)
      restaurant = Restaurant.find(restaurant.id)

      restaurant.photos.delete(primary_photo)
      restaurant = Restaurant.find(restaurant.id)

      restaurant.primary_photo.should be_nil
    end

    it "reselects primary photo of restaurant when current primary photo is deleted and other photos exist" do
      restaurant = Factory(:restaurant)
      restaurant.photos.create!(photo_attributes)
      restaurant.photos.create!(photo_attributes)
      restaurant.photos.create!(photo_attributes)
      restaurant.update_attributes!(:primary_photo => restaurant.photos.last)
      restaurant = Restaurant.find(restaurant.id)

      restaurant.photos.delete(restaurant.photos.last)
      restaurant = Restaurant.find(restaurant.id)

      restaurant.primary_photo.should == restaurant.photos.first
    end

    it "maintains the same primary photo when removing a non-primary photo" do
      restaurant = Factory(:restaurant)
      restaurant.photos.create!(photo_attributes)
      primary_photo = restaurant.photos.create!(photo_attributes)
      restaurant.photos.create!(photo_attributes)
      restaurant.update_attributes!(:primary_photo => primary_photo)
      restaurant = Restaurant.find(restaurant.id)

      restaurant.photos.delete(restaurant.photos.last)
      restaurant = Restaurant.find(restaurant.id)
      
      restaurant.primary_photo.should == primary_photo
    end
  end

  describe "public employment" do
    it "should get only public employments" do
      restaurant = Factory(:restaurant)
      public_employment = Factory(:employment, :public_profile => true,
          :restaurant => restaurant)
      private_employment = Factory(:employment, :public_profile => false,
          :restaurant => restaurant)
      restaurant.public_employments.should == [public_employment]
    end
  end
  
  describe "premium account" do
    
    it "finds a premium account" do
      restaurant = Factory(:restaurant)
      restaurant.subscription = Factory(:subscription)
      restaurant.account_type.should == "Premium"
      Restaurant.find_premium(restaurant.id).should == restaurant
    end
    
    it "doesn't find a basic account" do
      restaurant = Factory(:restaurant)
      restaurant.account_type.should == "Basic"
      Restaurant.find_premium(restaurant.id).should be_nil
    end
    
  end
  
end


# == Schema Information
#
# Table name: restaurants
#
#  id                         :integer         not null, primary key
#  name                       :string(255)
#  street1                    :string(255)
#  street2                    :string(255)
#  city                       :string(255)
#  state                      :string(255)
#  zip                        :string(255)
#  country                    :string(255)
#  facts                      :text
#  created_at                 :datetime
#  updated_at                 :datetime
#  manager_id                 :integer
#  metropolitan_area_id       :integer
#  james_beard_region_id      :integer
#  cuisine_id                 :integer
#  deleted_at                 :datetime
#  description                :string(255)
#  phone_number               :string(255)
#  website                    :string(255)
#  twitter_username           :string(255)
#  facebook_page              :string(255)
#  hours                      :string(255)
#  media_contact_id           :integer
#  management_company_name    :string(255)
#  management_company_website :string(255)
#  logo_id                    :integer
#  primary_photo_id           :integer
#  opening_date               :date
#

