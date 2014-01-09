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

  describe ".ContentRequest.title" do
    it "should return the title" do
      content_request = FactoryGirl.create(:content_request)
      ContentRequest.title.should == "Question from RIA"
    end   
  end
  
  describe "#inbox_title" do
    it "should return the inbox title" do
      content_request = FactoryGirl.create(:content_request)
      content_request.inbox_title.should == content_request.class.title
    end   
  end

  describe "#mailer_method" do
    it "should return the mailer method" do
      content_request = FactoryGirl.create(:content_request)
      content_request.mailer_method.should == content_request.mailer_method
    end   
  end

  describe "#message" do
    it "should return the message" do
      content_request = FactoryGirl.create(:content_request)
      content_request.message.should == [content_request.subject, content_request.body].compact.join(': ')
    end   
  end

  describe "#update_restaurants_from_search_criteria" do
    it "should update restaurants from search criteria" do
      content_request = FactoryGirl.create(:content_request)
      content_request.update_restaurants_from_search_criteria.should == content_request.employment_search.restaurant_ids
    end   
  end


  describe "#recipients_can_reply?" do
    it "should return true" do
      content_request = FactoryGirl.create(:content_request)
      content_request.recipients_can_reply?.should == true
    end   
  end

end
