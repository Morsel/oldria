require_relative '../spec_helper'

describe ContentRequest do
  it { should belong_to :employment_search }
  it { should have_many(:admin_discussions) }
  it { should have_many(:restaurants).through(:admin_discussions) }
  
  describe "restaurants" do
    before do
      @restaurant1 = FactoryGirl.create(:restaurant, :name => "Megan's Place")
      @employment1 = FactoryGirl.create(:employment, :restaurant => @restaurant1)
      @restaurant2 = FactoryGirl.create(:restaurant, :name => "Joe's Diner")
      @employment2 = FactoryGirl.create(:employment, :restaurant => @restaurant2)
    end

    it "should update based on the search criteria" do
      employment_search = FactoryGirl.create(:employment_search, :conditions => {
        :restaurant_name_like => 'megan'
      })
      content_request = FactoryGirl.build(:content_request, :employment_search => employment_search)
      content_request.save
      content_request.restaurants.should == employment_search.restaurants
      content_request.restaurants.should_not include(@restaurant2)
    end
  end
  
end
