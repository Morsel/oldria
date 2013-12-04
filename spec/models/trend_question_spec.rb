require_relative '../spec_helper'

describe TrendQuestion do
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
      trend_question = Factory.build(:trend_question, :employment_search => employment_search)
      trend_question.save
      trend_question.restaurants.should include(@restaurant1)
      trend_question.restaurants.should_not include(@restaurant2)
    end
    
    it "should update based on the search criteria" do
      employment_search = Factory(:employment_search, :conditions => {
        :restaurant_name_like => 'megan'
      })
      trend_question = Factory.build(:trend_question, :employment_search => employment_search)
      trend_question.save
      trend_question.restaurants.should include(@restaurant1)
      trend_question.employment_search.conditions = {:restaurant_name_like => 'joe'}
      trend_question.save
      trend_question.restaurants.should_not include(@restaurant1)
    end
  end
end


