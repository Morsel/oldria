require_relative '../spec_helper'

describe PromotionsController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @restaurant = FactoryGirl.create(:restaurant, :manager => @user)
    @promotion = FactoryGirl.create(:promotion, :restaurant_id => @restaurant.id)
    controller.stubs(:current_user).returns(@user)
  end

  it "index action should render index template" do
    get :index,:restaurant_id=>@restaurant.id
    response.should render_template(:index)
  end

  it "new action should render new template" do
    get :new,:restaurant_id=>@restaurant.id
    response.should render_template(:new)
  end

  it "delete_attachment" do
    get :delete_attachment,:restaurant_id=>@restaurant.id,:id=>@promotion.id
    response.should redirect_to(edit_restaurant_promotion_path(@restaurant, @promotion))
  end

  describe "POST create" do

    describe "with valid params" do
      before(:each) do
        Promotion.stubs(:new).returns(@promotion)
        Promotion.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created promotion as @promotion" do
        post :create, :promotion => {},:restaurant_id=>@restaurant.id
        assigns[:promotion].should equal(@promotion)
      end

      it "redirects to the created promotion" do
        post :create, :promotion => {},:restaurant_id=>@restaurant.id
        response.should redirect_to :action => :new
      end
    end
    describe "with invalid params" do
      before(:each) do
        Promotion.any_instance.stubs(:save).returns(false)
        Promotion.stubs(:new).returns(@promotion)
      end

      it "assigns a newly created but unsaved promotion as @promotion" do
        post :create, :promotion => {:these => 'params'},:restaurant_id=>@restaurant.id
        assigns[:promotion].should equal(@promotion)
      end

      it "re-renders the 'new' template" do
        post :create, :promotion => {},:restaurant_id=>@restaurant.id
        response.should render_template(:action=> "edit")
      end
    end
  end 
 
  describe "PUT update" do

    describe "with valid params" do
      before(:each) do
        Promotion.stubs(:find).returns(@promotion)
        Promotion.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested promotion" do
        Promotion.expects(:find).with("37").returns(@promotion)
        put :update, :id => "37", :promotion => {:these => 'params'},:restaurant_id=>@restaurant.id
      end

      it "assigns the requested promotion as @promotion" do
        Promotion.stubs(:find).returns(@promotion)
        put :update, :id => "1",:restaurant_id=>@restaurant.id
        assigns[:promotion].should equal(@promotion)
      end

      it "redirects to all promotion" do
        Promotion.stubs(:find).returns(@promotion)
        put :update, :id => "1",:restaurant_id=>@restaurant.id
        response.should redirect_to :action => :new
      end
    end

    describe "with invalid params" do
      before(:each) do
        Promotion.stubs(:find).returns(@promotion)
        Promotion.any_instance.stubs(:update_attributes).returns(false)
      end

      it "updates the requested promotion" do
        Promotion.expects(:find).with("37").returns(@promotion)
        put :update, :id => "37", :promotion => {:these => 'params'},:restaurant_id=>@restaurant.id
      end

      it "assigns the promotion as @promotion" do
        put :update, :id => "1",:restaurant_id=>@restaurant.id
        assigns[:promotion].should equal(@promotion)
      end

      it "re-renders the 'edit' template" do
        Promotion.stubs(:find).returns(@promotion)
        put :update, :id => "1",:restaurant_id=>@restaurant.id
        response.should render_template(:action=> "edit")
      end
    end
  end

  it "details" do
    get :details, :id => @promotion.id,:restaurant_id=>@restaurant.id
    response.should render_template(:details)
    response.should be_success
  end

  it "preview" do
    get :preview, :id => @promotion.id,:restaurant_id=>@restaurant.id
    response.should render_template(:preview)
    response.should be_success
  end


end
