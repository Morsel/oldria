require File.dirname(__FILE__) + '/../spec_helper'

describe EmployeesController do
  integrate_views

  before(:each) do
    @restaurant = Factory.stub(:restaurant)
    @employee = Factory(:user, :name => "John Doe")
    @employee.stubs(:managed_restaurants).returns([@restaurant])
    Restaurant.stubs(:find).returns(@restaurant)
    controller.stubs(:current_user).returns(@employee)
  end

  describe "GET index" do
    before(:each) do
      @restaurant.stubs(:employees).returns([@employee])
      get :index, :restaurant_id => @restaurant.id
    end

    it { response.should be_success }

    it "should assign @restaurant" do
      assigns[:restaurant].should == @restaurant
    end

    it "should assign @employees, scoped by the restaurant" do
      assigns[:employees].should == @restaurant.employees
    end
  end

  describe "GET new" do
    before(:each) do
      get :new, :restaurant_id => @restaurant.id
    end

    it { response.should be_success }

    it "should assign @restaurant" do
      assigns[:restaurant].should == @restaurant
    end

    it { assigns[:employment].should be_a(Employment) }

    it "should have a form with employee[name]" do
      response.should have_selector("form", :action => "/restaurants/#{@restaurant.id}/employees") do |form|
        form.should have_selector("input", :name => "employment[employee_name]")
      end
    end
  end

  describe "POST create" do
    context "when user exists" do
      before(:each) do
        User.stubs(:find_by_name).returns(@employee)
        post :create, :restaurant_id => @restaurant.id, :employment=> {:employee_name => "John Doe"}
      end

      it "should assign @restaurant" do
        assigns[:restaurant].should == @restaurant
      end

      it "should assign a found employee" do
        assigns[:employment].employee.should == @employee
      end
    end

    context "when user is new" do
      before(:each) do
        User.stubs(:find_by_name)
        post :create, :restaurant_id => @restaurant.id, :employee => {}
      end

      it { response.should render_template('new') }

      it "should flash an error message" do
        response.flash[:error].should_not be_nil
      end
    end
  end
end
