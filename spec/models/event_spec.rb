require_relative '../spec_helper'

describe Event do
  it { should belong_to(:restaurant) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for(:attachments) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:start_at) }
  it { should validate_presence_of(:end_at) }
  it { should validate_presence_of(:category) }
  it { should validate_presence_of(:location) }


  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:event)
  end

  it "should create a new instance given valid attributes" do
    Event.create!(@valid_attributes)
  end
  
  it "should be required to have a status if it's a private event" do
    params = FactoryGirl.attributes_for(:event, :category => "Private")
    event = Event.create(params)
    event.should have(1).error_on(:status)
  end
  
  it "should be required to have a location" do
    params = FactoryGirl.attributes_for(:event, :category => "Holiday", :location => nil)
    event = Event.create(params)
    event.should have(1).error_on(:location)
  end
  
  it "shouldn't be required to have a location if it's an admin event" do
    params = FactoryGirl.attributes_for(:event, :category => "admin_holiday", :location => nil)
    event = Event.create(params)
    event.should have(0).errors_on(:location)
  end

  describe "#date" do
    it "should return start_at date" do
      event = FactoryGirl.build(:event)
      event.date.should ==  event.start_at
    end 
  end

  describe "#calendar" do
    it "should return calendar date" do
      event = FactoryGirl.build(:event)
      if event.category = "admin_charity"
        event.calendar.should ==  "Charity"
      elsif event.category = "admin_holiday"
        event.calendar.should ==  "Holiday"
      end    
    end 
  end

  describe "#children" do
    it "should return children" do
      event = FactoryGirl.build(:event)
        unless event.restaurant_id
        @children =  Event.children(self)
        end
      event.children.should ==  @children
    end 
  end

  describe "#child_count" do
    it "should return children" do
      event = FactoryGirl.build(:event)
      unless event.restaurant_id
        @child_count = Event.count(:conditions => { :parent_id => event.id })
      end
      event.child_count.should ==  @child_count
    end 
  end

  describe "#parent" do
    it "should return parent" do
      event = FactoryGirl.build(:event)
      if event.parent_id
      @parent_id = Event.find(event.parent_id)
      end   
      event.parent.should == @parent_id
    end 
  end

  describe "#private?" do
    it "should return private?" do
      event = FactoryGirl.build(:event)
      if event.category == "Private"
        event.private?.should == true
      else
        event.private?.should == false
      end   
    end 
  end

  describe "#accepted_for_restaurant?" do
    it "should return private?" do
      event = FactoryGirl.build(:event)
      restaurant = FactoryGirl.build(:restaurant)
      event.accepted_for_restaurant?(restaurant).should == event.child_count > 0 && !Event.children(event).find(:first, :restaurant_id == event.restaurant.id).nil?
    end 
  end

end
