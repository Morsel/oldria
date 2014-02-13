require_relative '../spec_helper'

describe EventsController do
  before(:each) do
    fake_normal_user
    @restaurant = FactoryGirl.create(:restaurant)
    @event = FactoryGirl.create(:event, :restaurant => @restaurant)
    @restaurant.employees << @user
  end

  it "new action should render new template" do
    get :new, :restaurant_id => @restaurant
    response.should render_template(:new)
  end

  describe "POST create" do
    describe "with valid params" do
      before(:each) do
        Event.stubs(:new).returns(@event)
        Event.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created event as @event" do
        post :create, :event => {}, :restaurant_id => @restaurant
        assigns[:event].should equal(@event)
      end

      it "redirects to the created event" do
        post :create, :event => {}, :restaurant_id => @restaurant
        response.should redirect_to(restaurant_calendars_path(@restaurant))
      end
    end
    describe "with invalid params" do
      before(:each) do
        Event.any_instance.stubs(:save).returns(false)
        Event.stubs(:new).returns(@event)
      end

      it "assigns a newly created but unsaved event as @event" do
        post :create, :event => {:these => 'params'}, :restaurant_id => @restaurant
        assigns[:event].should equal(@event)
      end

      it "re-renders the 'new' template" do
        post :create, :event => {}, :restaurant_id => @restaurant
        response.should render_template(:action=> "new")
      end
    end
  end

  it "show action should render show template" do
    get :show, :restaurant_id => @restaurant.id,:id=>@event.id
    response.should render_template(:show)
  end

  describe "PUT update" do

    describe "with valid params" do
      before(:each) do
        Event.stubs(:find).returns(@event)
        Event.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested event" do
        Event.expects(:find).with("37").returns(@event)
        put :update, :id => "37", :event => {:these => 'params'}, :restaurant_id => @restaurant.id
      end

      it "assigns the requested event as @event" do
        Event.stubs(:find).returns(@event)
        put :update, :id => "1", :restaurant_id => @restaurant
        assigns[:event].should equal(@event)
      end

      it "redirects to all event" do
        Event.stubs(:find).returns(@event)
        put :update, :id => "1", :restaurant_id => @restaurant
        response.should redirect_to restaurant_calendars_path(@restaurant)
      end
    end

    describe "with invalid params" do
      before(:each) do
        Event.stubs(:find).returns(@event)
        Event.any_instance.stubs(:update_attributes).returns(false)
      end

      it "updates the requested event" do
        Event.expects(:find).with("37").returns(@event)
        put :update, :id => "37", :event => {:these => 'params'}, :restaurant_id => @restaurant
      end

      it "assigns the event as @event" do
        put :update, :id => "1", :restaurant_id => @restaurant
        assigns[:event].should equal(@event)
      end

      it "re-renders the 'edit' template" do
        Event.stubs(:find).returns(@event)
        put :update, :id => "1", :restaurant_id => @restaurant
        response.should render_template(:action=> "edit")
      end
    end
  end

  describe "GET edit" do
    it "assigns the requested event as @event" do
      Event.stubs(:find).returns(@event)
      get :edit, :id => "37", :restaurant_id => @restaurant
      assigns[:event].should equal(@event)
    end
  end
 
  it "ria_details" do
    get :ria_details, :restaurant_id => @restaurant,:id=>@event.id
    response.should be_success
  end

  it "transfer" do
    get :transfer, :restaurant_id => @restaurant,:id=>@event.id
    response.should be_success
  end
end
