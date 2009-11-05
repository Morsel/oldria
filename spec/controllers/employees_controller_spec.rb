require File.dirname(__FILE__) + '/../spec_helper'

describe EmployeesController do
  integrate_views

  before(:each) do
    @restaurant = Factory.stub(:restaurant)
    @employee = Factory(:user, :name => "John Doe", :email => "john@example.com")
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
    context "with no params" do
      before(:each) do
        get :new, :restaurant_id => @restaurant.id
      end

      it { response.should be_success }

      it { assigns[:restaurant].should == @restaurant }
      it { assigns[:employment].should be_an(Employment) }

      it "should have a form to NEW action with employee[email]" do
        response.should have_selector("form", :action => "/restaurants/#{@restaurant.id}/employees/new") do |form|
          form.should have_selector("input", :name => "employment[employee_email]")
        end
      end
    end

    context "after trying to find an existing employee" do
      before(:each) do
        User.stubs(:find_by_email).returns(@employee)
        get :new, :restaurant_id => @restaurant.id, :employment => {:employee_email => "john@example.com"}
      end
      
      it { response.should be_success }
      it { response.should render_template(:confirm_employee)}

      it { assigns[:restaurant].should == @restaurant }
      it { assigns[:employment].should be_an(Employment) }
      it { assigns[:employee].should == @employee }
      
      it "should include confirmation message" do
        response.should contain("Is this who you were looking for?")
      end
      
      it "should have a form to POST create action with hidden employee[email]" do
        response.should have_selector("form", :action => "/restaurants/#{@restaurant.id}/employees") do |form|
          form.should have_selector("input", :name => "employment[employee_email]", :type => 'hidden')
        end
      end
    end
    
    context "after trying to find a non-existing employee" do
      before(:each) do
        User.stubs(:find_by_email)
        get :new, :restaurant_id => @restaurant.id, :employment => {:employee_email => "john@example.com"}
      end
      it { response.should be_success }
      it { response.should render_template(:new_employee)}

      it { assigns[:restaurant].should == @restaurant }
      it { assigns[:employment].should be_an(Employment) }
      it { assigns[:employee].should be_new_record }
      
      it "should have a form to POST create action with hidden employee[email]" do
        response.should have_selector("form", :action => "/restaurants/#{@restaurant.id}/employees") do |form|
          form.should have_selector("input", :name => "employment[employee_attributes][email]", :value => "john@example.com")
        end
      end
    end
  end

  describe "POST create" do
    context "when user exists" do
      before(:each) do
        User.stubs(:find_by_email).returns(@employee)
        post :create, :restaurant_id => @restaurant.id, :employment=> {:employee_email => "John Doe"}
      end

      it "should assign @restaurant" do
        assigns[:restaurant].should == @restaurant
      end

      it "should assign a found employee" do
        assigns[:employment].employee.should == @employee
      end
      
      it { should redirect_to(restaurant_employees_path(@restaurant))}
    end
    
    context "when user is new and valid" do
      before(:each) do
        user_attrs = Factory.attributes_for(:user, :name => "John Doe", :email => 'john@simple.com')
        User.stubs(:find_by_email)
        User.any_instance.stubs(:valid?).returns(true)
        User.any_instance.stubs(:save).returns(true)
        Employment.any_instance.stubs(:save).returns(true)
        post :create, :restaurant_id => @restaurant.id, :employment=> {:employee_attributes => user_attrs }
      end

      it "should assign @restaurant" do
        assigns[:restaurant].should == @restaurant
      end

      it "should assign a found employee" do
        assigns[:employment].employee.name.should == "John Doe"
      end
      
      it { should redirect_to(restaurant_employees_path(@restaurant))}

    end

    context "when user is new but invalid" do
      before(:each) do
        user_attrs = Factory.attributes_for(:user, :name => "John Doe", :email => 'john@simple.com')
        User.stubs(:find_by_email)
        User.any_instance.stubs(:valid?).returns(false)
        Employment.any_instance.stubs(:save).returns(false)
        post :create, :restaurant_id => @restaurant.id, :employment=> {:employee_attributes => user_attrs }
      end
      
      it { should render_template(:new_employee) }
    end
  end
end
