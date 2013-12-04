require_relative '../spec_helper'

describe Admin::RestaurantRolesController do
  integrate_views
  before(:each) do
    @user = Factory.stub(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    @restaurant_role = Factory.stub(:restaurant_role)
    RestaurantRole.stubs(:find).returns(@restaurant_role)
  end

  context "GET index" do
    it "should render index template" do
      RestaurantRole.stubs(:find).returns([@restaurant_role])
      get :index
      response.should render_template(:index)
    end
  end

  context "GET new" do
    it "should render new template" do
      get :new
      response.should render_template(:new)
    end
  end

  context "POST create" do
    it "should render new template when model is invalid" do
      RestaurantRole.any_instance.stubs(:valid?).returns(false)
      post :create
      response.should render_template(:new)
    end

    it "should redirect when model is valid" do
      RestaurantRole.any_instance.stubs(:valid?).returns(true)
      post :create
      response.should redirect_to(admin_restaurant_roles_url)
    end
  end

  context "GET edit" do
    it "should render edit template" do
      get :edit, :id => RestaurantRole.first
      response.should render_template(:edit)
    end
  end

  context "PUT update" do
    before(:each) do
      @restaurant_role = Factory(:restaurant_role)
      RestaurantRole.stubs(:find).returns(@restaurant_role)
    end

    it "should render edit template when model is invalid" do
      RestaurantRole.any_instance.stubs(:valid?).returns(false)
      put :update, :id => RestaurantRole.first
      response.should render_template(:edit)
    end

    it "should redirect when model is valid" do
      RestaurantRole.any_instance.stubs(:valid?).returns(true)
      put :update, :id => RestaurantRole.first
      response.should redirect_to(admin_restaurant_roles_url)
    end
  end

  context "DELETE destroy" do
    before(:each) do
      @restaurant_role = Factory(:restaurant_role)
      RestaurantRole.stubs(:find).returns(@restaurant_role)
    end

    it "should destroy model and redirect to index action" do
      restaurant_role = RestaurantRole.first
      delete :destroy, :id => restaurant_role
      response.should redirect_to(admin_restaurant_roles_url)
      RestaurantRole.exists?(restaurant_role.id).should be_false
    end
  end

  describe "categories" do

    it "should update a role's category" do
      role = Factory(:restaurant_role)
      RestaurantRole.stubs(:find).returns(role)
      role.expects(:update_attributes).with("category" => "New category")
      put :update_category, :role_id => role.id, :restaurant_role => { :category => "New category" }
    end

  end

end
