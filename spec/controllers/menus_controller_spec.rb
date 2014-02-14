require_relative '../spec_helper'

describe MenusController do
 before(:each) do
    @user = FactoryGirl.create(:admin)
    @restaurant = FactoryGirl.create(:restaurant)
    @menu = FactoryGirl.create(:menu,:restaurant => @restaurant)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  it "index action should render index template" do
    get :index,:restaurant_id => @restaurant.id
    response.should render_template(:index)
  end

  it "bulk_edit action should render bulk_edit template" do
    get :bulk_edit,:restaurant_id => @restaurant.id
    response.should render_template(:bulk_edit)
  end

  describe "POST create" do

    describe "with valid params" do
      before(:each) do
        Menu.stubs(:new).returns(@menu)
        Menu.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created menu as @menu" do
        post :create, :menu => {},:restaurant_id => @restaurant.id
        assigns[:menu].should equal(@menu)
      end

      it "redirects to the created menu" do
        post :create, :menu => {},:restaurant_id => @restaurant.id
        response.should redirect_to bulk_edit_restaurant_menus_path(@restaurant)
      end
    end

    describe "with invalid params" do
      before(:each) do
        Menu.any_instance.stubs(:save).returns(false)
        Menu.stubs(:new).returns(@menu)
      end

      it "assigns a newly created but unsaved menu as @menu" do
        post :create, :menu => {:these => 'params'},:restaurant_id => @restaurant.id
        assigns[:menu].should equal(@menu)
      end

      it "re-renders the 'new' template" do
        post :create, :menu => {},:restaurant_id => @restaurant.id
        response.should render_template(:action=> "bulk_edit")
      end
    end
  end
   
    describe "with valid params" do
      before(:each) do
        Menu.stubs(:find).returns(@menu)
        Menu.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested menu" do
        Menu.expects(:find).with("1").returns(@menu)
        put :update, :id => "1", :menu => {:these => 'params'},:restaurant_id => @restaurant.id
      end

      it "assigns the requested menu as @menu" do
        Menu.stubs(:find).returns(@menu)
        put :update, :id => "1",:restaurant_id => @restaurant.id
        assigns[:menu].should equal(@menu)
      end

      it "redirects to all menu" do
        Menu.stubs(:find).returns(@menu)
        put :update, :id => "1",:restaurant_id => @restaurant.id
        response.should redirect_to bulk_edit_restaurant_menus_path(@restaurant)
      end
    end
  end 

  describe "POST reorder" do
      @menu_a = FactoryGirl.create(:menu, :position => "1", :restaurant => @restaurant)
      @menu_b = FactoryGirl.create(:menu, :position => "2", :restaurant => @restaurant)
      @menu_c = FactoryGirl.create(:menu, :position => "3", :restaurant => @restaurant)
    it "should reorder based on ids" do
      post :reorder, :restaurant_id => @restaurant.id,
          :menu => [@menu_b.id, @menu_c.id, @menu_a.id]
      @restaurant.reload.menus.by_position.should == [@menu_b, @menu_c, @menu_a]
    end

  describe "DELETE destroy" do
    it "destroys the requested menu" do
      Menu.expects(:find).with("37").returns(@menu)
      @menu.expects(:destroy)
      delete :destroy, :id => "37"
      response.should redirect_to(bulk_edit_restaurant_menus_path(@restaurant))
    end
  end 

  end


