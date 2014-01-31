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

  it "create action should render new template when model is invalid" do
    Menu.any_instance.stubs(:valid?).returns(false)
    post :create,:restaurant_id => @restaurant.id
    response.should render_template(:action=> "bulk_edit")
  end

  describe "POST reorder" do

    let(:restaurant) { FactoryGirl.create(:restaurant) }

    before(:each) do
      fake_admin_user
      @menu_a = FactoryGirl.create(:menu, :position => "1", :restaurant => restaurant)
      @menu_b = FactoryGirl.create(:menu, :position => "2", :restaurant => restaurant)
      @menu_c = FactoryGirl.create(:menu, :position => "3", :restaurant => restaurant)
    end

    it "should reorder based on ids" do
      post :reorder, :restaurant_id => restaurant.id,
          :menu => [@menu_b.id, @menu_c.id, @menu_a.id]
      restaurant.reload.menus.by_position.should == [@menu_b, @menu_c, @menu_a]
    end
  end



end