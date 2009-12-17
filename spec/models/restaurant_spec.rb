require 'spec/spec_helper'

describe Restaurant do
  should_belong_to :manager, :class_name => "User"
  should_belong_to :metropolitan_area
  should_belong_to :james_beard_region
  should_belong_to :cuisine
  should_have_many :employments
  should_have_many :employees, :through => :employments
  should_have_many :media_request_conversations, :through => :employments

  it "should belong to a manager (user)" do
    user = Factory(:user)
    restaurant = Restaurant.create(:name => "Moon Lodge", :manager => user)
    restaurant.save
    restaurant2 = Restaurant.find(restaurant.id)
    restaurant2.manager.should == user
  end

  it "should have many media request conversations through its employments" do
    restaurant = Factory(:restaurant)
    employment = Factory(:employment, :restaurant => restaurant)
    mr = Factory(:media_request_conversation, :recipient => employment)
    restaurant.media_request_conversations.should == [mr]
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
end
