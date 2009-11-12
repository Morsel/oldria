require File.dirname(__FILE__) + '/../spec_helper'

describe EmployeesController do
  integrate_views

  before(:each) do
    @restaurant = Factory(:restaurant)
    @employee = Factory(:user, :name => "John Doe", :email => "john@example.com")
    @employee.stubs(:managed_restaurants).returns([@restaurant])
    @employee.stubs(:restaurants)
    Restaurant.stubs(:find).returns(@restaurant)
    controller.stubs(:current_user).returns(@employee)
  end

  describe "GET index" do
    before(:each) do
      @employment = Factory(:employment, :employee => @employee, :restaurant => @restaurant)
      @restaurant.stubs(:employments).returns([@employment])
      get :index, :restaurant_id => @restaurant.id
    end

    it { response.should be_success }

    it "should assign @restaurant" do
      assigns[:restaurant].should == @restaurant
    end

    it "should assign @employments, scoped by the restaurant" do
      assigns[:employments].should == @restaurant.employments
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
        @employment.stubs(:save).returns(true)
        post :create, :restaurant_id => @restaurant.id, :employment=> {:employee_email => "john@example.com"}
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

  describe "GET edit" do
    before(:each) do
      @restaurant2 = Factory(:restaurant)
      Restaurant.stubs(:find).returns(@restaurant2)
      @employment = Factory(:employment, :restaurant => @restaurant2, :employee => @employee)
      get :edit, :id => @employee.id, :restaurant_id => @restaurant2.id
    end

    it "should respond successfully" do
      response.should be_success
    end

    it "should assign @employment" do
      assigns[:employment].should == @employment
    end

    it "should assign @employee" do
      assigns[:employee].should == @employee
    end

    it "should have a form to edit the employment" do
      response.should have_selector("form", :action => restaurant_employee_path(@employee))
    end
  end

  describe "PUT update" do
    before(:each) do
      @restaurant2 = Factory(:restaurant)
      Restaurant.stubs(:find).returns(@restaurant2)
      @employment = Factory(:employment, :restaurant => @restaurant2, :employee => @employee)
    end

    context "when update is successful" do
      before do
        put :update, :id => @employee.id, :restaurant_id => @restaurant2.id, :employment => {}
      end

      it { should redirect_to(restaurant_employees_path(@restaurant2))}

      it "should set a flash message" do
        flash[:notice].should_not be_nil
      end
    end

    context "when update is not successful" do
      before do
        Employment.any_instance.stubs(:valid?).returns(false)
        put :update, :id => @employee.id, :restaurant_id => @restaurant2.id, :employment => {}
      end

      it { should redirect_to(restaurant_employees_path(@restaurant2))}

      it "should set a flash error" do
        flash[:error].should_not be_nil
      end
    end
  end

end
