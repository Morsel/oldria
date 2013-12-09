require_relative '../spec_helper'

describe TrendQuestion do
  it { should belong_to :employment_search }
  it { should have_many :admin_discussions }
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
      trend_question = FactoryGirl.build(:trend_question, :employment_search => employment_search)
      trend_question.save
      trend_question.restaurants.should include(@restaurant1)
      trend_question.restaurants.should_not include(@restaurant2)
    end
    
    it "should update based on the search criteria" do
      employment_search = FactoryGirl.create(:employment_search, :conditions => {
        :restaurant_name_like => 'megan'
      })
      trend_question = FactoryGirl.build(:trend_question, :employment_search => employment_search)
      trend_question.save
      trend_question.restaurants.should include(@restaurant1)
      trend_question.employment_search.conditions = {:restaurant_name_like => 'joe'}
      trend_question.save
      trend_question.restaurants.should_not include(@restaurant1)
    end
  end
end


