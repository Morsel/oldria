require_relative '../spec_helper'

describe Restaurant do
  it { should belong_to(:manager).class_name("User") }
  it { should belong_to(:metropolitan_area) }
  it { should belong_to(:james_beard_region) }
  it { should belong_to(:cuisine) }
  it { should have_many(:employments) }
  it { should have_many(:employees).through(:employments) }
  it { should have_many(:admin_discussions) }
  it { should have_many(:media_request_discussions) }
  it { should have_many(:media_requests).through(:media_request_discussions) }
  it { should have_many(:trend_questions).through(:admin_discussions) }
  it { should have_many(:content_requests).through(:admin_discussions) }

  describe "manager and employees" do
    it "should belong to a manager (user)" do
      user = FactoryGirl.create(:user)
      restaurant = FactoryGirl.create(:restaurant, :name => "Moon Lodge", :manager => user)
      restaurant.save
      restaurant2 = Restaurant.find(restaurant.id)
      restaurant2.manager.should == user
    end

    it "should add the manager as an omniscient employee on create" do
      manager = FactoryGirl.create(:user, :name => "Jim John")
      restaurant = FactoryGirl.build(:restaurant, :manager => manager)
      restaurant.employees.should be_empty
      restaurant.save
      restaurant.employees.count.should == 1
      restaurant.employees.first.should == manager
      restaurant.employments.first.omniscient.should be_true
    end
  end

  # Managers now get all subject matters by default, so
  # there should no longer be the possibility of some remaining unassigned
  #
  # describe "missing_subject_matters" do
  #   it "should know which subject matters are missing" do
  #     %w(Beer Other Beverage Food Business Wine Pastry).each do |sm|
  #       FactoryGirl.create(:subject_matter, :name => sm)
  #     end
  # 
  #     handled_subject = SubjectMatter.find_by_name("Pastry")
  # 
  #     employment = FactoryGirl.create(:employment, :subject_matters => [handled_subject])
  #     restaurant = employment.restaurant
  # 
  #     %w(Beer Other Beverage Food Business Wine).each do |sm|
  #       restaurant.missing_subject_matters.map(&:name).should include(sm)
  #     end
  #     restaurant.missing_subject_matters.should_not include(handled_subject)
  #   end
  # end

  describe "safe deletion" do
    it "should not actually delete Restaurants" do
      restaurant = FactoryGirl.create(:restaurant)
      Restaurant.all.should == [restaurant]
      restaurant.destroy
      Restaurant.count.should == 0
      Restaurant.with_destroyed { Restaurant.count }.should == 1
    end

    it "should delete an associated admin_discussion when restaurant is deleted" do
      restaurant = FactoryGirl.create(:restaurant)
      content_request = FactoryGirl.create(:content_request)
      content_request.restaurant_ids = [restaurant.id]
      content_request.admin_discussions.count.should == 1
      restaurant.destroy
      content_request.admin_discussions.count.should == 0
    end

    it "should delete an associated admin_discussion when restaurant is deleted" do
      restaurant = FactoryGirl.create(:restaurant)
      holiday = FactoryGirl.create(:holiday)
      holiday.restaurants = [restaurant]
      holiday_reminder = FactoryGirl.create(:holiday_reminder, :holiday => holiday)
      holiday_reminder.holiday_discussions.count.should == 1
      restaurant.destroy
      holiday_reminder.holiday_discussions.count.should == 0
    end
  end

  describe "media_contact" do
    it "can be assigned a media contact" do
      restaurant = FactoryGirl.create(:restaurant)
      media_contact = FactoryGirl.create(:user)
      restaurant.media_contact = media_contact
      restaurant.save!
      restaurant = Restaurant.find(restaurant.id)
      restaurant.media_contact.should == media_contact
    end
  end

  describe "update features" do

    let(:restaurant) { FactoryGirl.create(:restaurant) }
    let(:features) do
      %w(ugly pretty open closed).map do |value|
        RestaurantFeature.create!(:value => value)
      end
    end

    it "sets feature list from ids" do
      restaurant.reset_features([features[0].id, features[1].id])
      restaurant.restaurant_features.should == [features[0], features[1]]
    end

    it "should reset features if features change" do
      restaurant.restaurant_features = [features[1], features[3]]
      restaurant.reset_features([features[0].id], [features[1].id, features[3].id])
      restaurant.restaurant_features.should == [features[0]]
    end

  end

  describe "feature pages and categories" do

    let(:restaurant) { FactoryGirl.create(:restaurant) }
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
      r2 = FactoryGirl.create(:restaurant)
      r2.restaurant_features = [pretty, dinner]
      Restaurant.with_feature(ugly).should == [restaurant]
      Restaurant.with_feature(pretty).should =~ [restaurant, r2]
    end
  end

  describe "validate facebook URL" do

    subject { FactoryGirl.create(:restaurant) }
    it { should accept_values_for(:facebook_page_url, nil, "", "http://www.facebook.com/fred",
        "http://www.facebook.com/profile.php?id=23423",
        "http://www.facebook.com/pages/Random-Restaurant/11746961621") }
    it { should_not accept_values_for(:facebook_page_url, "fred", "@noelrap",
        "http://www.twitter.com/noelrap") }

  end

  describe "photos" do

    let(:photo_attributes) {{:attachment_content_type => "image/png", :attachment_file_name => "somefile.jpg", :credit => "Joe Pesci"}}

    it "selects the first photo added as the primary photo" do
      restaurant = FactoryGirl.create(:restaurant)
      restaurant.photos.create!(photo_attributes)

      restaurant = Restaurant.find(restaurant.id)
      restaurant.primary_photo.should == restaurant.photos.first
    end

    it "maintains the same primary photo when adding additional photos after the first one" do
      restaurant = FactoryGirl.create(:restaurant)
      restaurant.photos.create!(photo_attributes)
      primary_photo = restaurant.photos.create!(photo_attributes)
      restaurant.photos.create!(photo_attributes)
      restaurant.update_attributes!(:primary_photo => primary_photo)
      restaurant.photos.create!(photo_attributes)

      restaurant = Restaurant.find(restaurant.id)
      restaurant.primary_photo.should == primary_photo
    end

    it "unselects primary photo of restaurant when deleted and it is the only photo for the restaurant" do
      restaurant = FactoryGirl.create(:restaurant)
      primary_photo = restaurant.photos.create!(photo_attributes)
      restaurant.update_attributes!(:primary_photo => primary_photo)
      restaurant = Restaurant.find(restaurant.id)

      restaurant.photos.delete(primary_photo)
      restaurant = Restaurant.find(restaurant.id)

      restaurant.primary_photo.should be_nil
    end

    it "reselects primary photo of restaurant when current primary photo is deleted and other photos exist" do
      restaurant = FactoryGirl.create(:restaurant)
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
      restaurant = FactoryGirl.create(:restaurant)
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
      restaurant = FactoryGirl.create(:restaurant)
      # Set the manager to invisible for this test
      restaurant.employments.first.update_attribute(:public_profile, false)
      public_employment = FactoryGirl.create(:employment, :public_profile => true, :restaurant => restaurant)
      private_employment = FactoryGirl.create(:employment, :public_profile => false, :restaurant => restaurant)
      restaurant.public_employments.should == [public_employment]
    end
  end

  describe "premium account" do

    it "finds a premium account" do
      restaurant = FactoryGirl.create(:restaurant)
      restaurant.subscription = FactoryGirl.create(:subscription)
      restaurant.account_type.should == "Complimentary Premium"
      Restaurant.find_premium(restaurant.id).should == restaurant
    end

    it "doesn't find a basic account" do
      restaurant = FactoryGirl.create(:restaurant)
      restaurant.account_type.should == "Basic"
      Restaurant.find_premium(restaurant.id).should be_nil
    end

  end

  describe "braintree_contact" do
    let(:restaurant) { FactoryGirl.create(:restaurant) }

    it "should return manager" do
      restaurant.braintree_contact == restaurant.manager
    end
  end

  describe "extended_find" do
    it "find a restaurant by name" do
      restaurant = FactoryGirl.create(:restaurant, :name => "Vodka pub")
      restaurant.subscription = FactoryGirl.create(:subscription)
      found = Restaurant.extended_find("odka")
      found.should == [restaurant]
    end
  end

  describe "newsletter preview reminders" do

    it "should generate reminders for all premium restaurants" do
      restaurant = FactoryGirl.create(:restaurant)
      restaurant.subscription = FactoryGirl.create(:subscription)
      Restaurant.any_instance.expects(:send_later).with(:send_newsletter_preview_reminder)
      Restaurant.send_newsletter_preview_reminder
    end

  end

  describe "Mailchimp newsletters" do

    it "should send newsletters for premium restaurants when due" do
      restaurant = FactoryGirl.create(:restaurant, :next_newsletter_at => 1.day.ago)
      restaurant.subscription = FactoryGirl.create(:subscription)
      Restaurant.stubs(:find).returns([restaurant])
      # restaurant.expects(:send_later).with(:send_newsletter_to_subscribers)
      # restaurant.expects(:update_attribute).with(:next_newsletter_at, (Chronic.parse("next week Thursday 12:00am") + 1.week))

      Restaurant.send_newsletters
    end

  end

end



