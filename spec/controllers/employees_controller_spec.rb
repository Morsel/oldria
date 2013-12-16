require_relative '../spec_helper'

describe EmployeesController do
  integrate_views

  before(:each) do
    @manager = FactoryGirl.create(:user, :name => "Manager Doe", :email => "manager@example.com")
    @employee = FactoryGirl.create(:user, :name => "John Doe", :email => "john@example.com")
    @restaurant = FactoryGirl.create(:restaurant, :manager => @manager)
    @employee.stubs(:restaurants).returns([])
    @manager.stubs(:restaurants).returns([@restaurant])
    @manager.stubs(:managed_restaurants).returns([@restaurant])
    Restaurant.stubs(:find).returns(@restaurant)
    controller.stubs(:current_user).returns(@manager)
    controller.stubs(:preload_resources)
  end

  describe "GET bulk_edit" do
    before(:each) do
      @employments = @restaurant.employments
      @employment = @employments.first
      @restaurant.stubs(:employments).returns(@employments)
      get :bulk_edit, :restaurant_id => @restaurant.id
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
        User.stubs(:find_all_by_email).returns([@employee])
        get :new, :restaurant_id => @restaurant.id, :employment => {:employee_email => "john"}
      end

      it { response.should be_success }
      it { response.should render_template(:confirm_employee)}

      it { assigns[:restaurant].should == @restaurant }
      it { assigns[:employment].should be_an(Employment) }
      it { assigns[:employees].first.should == @employee }

      it "should include confirmation message" do
        response.should contain("Are these users an employee at your restaurant?")
      end

      it "should have a form to POST create action with hidden employee_id" do
        response.should have_selector("form", :action => "/restaurants/#{@restaurant.id}/employees") do |form|
          form.should have_selector("input", :name => "employment[employee_id]", :type => 'hidden', :value => "#{@employee.id}")
        end
      end
    end

    context "after trying to find a non-existing employee" do
      before(:each) do
        User.stubs(:find)
        get :new, :restaurant_id => @restaurant.id, :employment => {:employee_email => "sam@example.com"}
      end
      it { response.should be_success }#be_redirect }
      it { response.should be_success }#redirect_to(recommend_invitations_url(:emails => "sam@example.com" )) }
    end
  end

  describe "POST create" do
    context "when user exists" do
      
      before(:each) do
        
        @restaurant.employments.first.stubs(:save).returns(true)
        post :create, :restaurant_id => @restaurant.id, :employment=> {:employee_email => "john@example.com"}
      end

      it "should assign @restaurant" do
        assigns[:restaurant].should == @restaurant
      end
      
      it "should assign a found employee" do
        assigns[:employment].employee.should == @employee
      end

      it { should redirect_to(edit_restaurant_employee_path(@restaurant, @employee)) }
      
    end

    context "when user is new and valid" do
      
      before(:each) do
        user_attrs = FactoryGirl.attributes_for(:user, :name => "John Doe", :email => 'john@simple.com')
        post :create, :restaurant_id => @restaurant.id, :employment => { :employee_attributes => user_attrs.except(:confirmed_at) }
      end

      it "should assign @restaurant" do
        assigns[:restaurant].should == @restaurant
      end

      it "should assign a found employee" do
        assigns[:employment].employee.name.should == "John Doe"
      end

      it "should set the user's password (to a random token)" do
        assigns[:employee].password.should_not be_nil
      end

      it { should redirect_to(edit_restaurant_employee_path(@restaurant, assigns[:employee])) }

    end

    context "when user is new but invalid" do
      
      before(:each) do
        user_attrs = FactoryGirl.attributes_for(:user, :name => "John Doe", :email => 'john@simple.com')
        User.stubs(:find_by_email)
        User.any_instance.stubs(:valid?).returns(false)
        Employment.any_instance.stubs(:save).returns(false)
        post :create, :restaurant_id => @restaurant.id, :employment => { :employee_attributes => user_attrs.except(:confirmed_at) }
      end

      it { should render_template(:new_employee) }

    end
  end

  describe "GET edit" do
    before(:each) do
      @restaurant2 = FactoryGirl.create(:restaurant, :manager => @manager)
      Restaurant.stubs(:find).returns(@restaurant2)
      @employment = FactoryGirl.create(:employment, :restaurant => @restaurant2, :employee => @employee)
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
      response.should have_selector("form", :action => restaurant_employee_path(@restaurant2, @employee))
    end
  end

  describe "PUT update" do
    before(:each) do
      @restaurant2 = FactoryGirl.create(:restaurant, :manager => @manager)
      Restaurant.stubs(:find).returns(@restaurant2)
      @employment = FactoryGirl.create(:employment, :restaurant => @restaurant2, :employee => @employee,:restaurant_role=>FactoryGirl.create(:restaurant_role))
    end

    context "when update is successful" do
      before do
        put :update, :id => @employee.id, :restaurant_id => @restaurant2.id, :employment => {}
      end

      it { should redirect_to(bulk_edit_restaurant_employees_path(@restaurant2))}

      it "should set a flash message" do
        flash[:notice].should_not be_nil
      end
    end

    context "when update is not successful" do
      before do
        Employment.any_instance.stubs(:valid?).returns(false)
        put :update, :id => @employee.id, :restaurant_id => @restaurant2.id, :employment => {}
      end

      it { should render_template(:edit) }

      it "should set a flash error" do
        flash[:error].should_not be_nil
      end
    end
  end

end
