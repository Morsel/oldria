require_relative '../spec_helper'

describe RestaurantRole do
  it { should have_many :employments }
  it { should have_many(:employees).through(:employments) } 
  it { should have_many(:question_roles).dependent(:destroy) }   
  it { should have_many(:profile_questions).through(:question_roles) }   
  it { should validate_presence_of :name }

  describe ".order" do
    it "should return order" do
      restaurant_role = FactoryGirl.create(:restaurant_role)
      RestaurantRole.order.should == RestaurantRole.all(order: 'name ASC')
    end
  end

  describe ".categories" do
    it "should return categories" do
      restaurant_role = FactoryGirl.create(:restaurant_role)
      RestaurantRole.categories.should == RestaurantRole.all.map(&:category).uniq.reject { |c| c.blank? }
    end
  end


end

