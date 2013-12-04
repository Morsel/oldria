require_relative '../spec_helper'

describe ContentRequest do
  should_belong_to :employment_search
  should_have_many :admin_discussions, :as => :discussionable
  should_have_many :restaurants, :through => :admin_discussions
  
  describe "restaurants" do
    before do
      @restaurant1 = Factory(:restaurant, :name => "Megan's Place")
      @employment1 = Factory(:employment, :restaurant => @restaurant1)
      @restaurant2 = Factory(:restaurant, :name => "Joe's Diner")
      @employment2 = Factory(:employment, :restaurant => @restaurant2)
    end

    it "should update based on the search criteria" do
      employment_search = Factory(:employment_search, :conditions => {
        :restaurant_name_like => 'megan'
      })
      content_request = Factory.build(:content_request, :employment_search => employment_search)
      content_request.save
      content_request.restaurants.should == employment_search.restaurants
      content_request.restaurants.should_not include(@restaurant2)
    end
  end
  
end
