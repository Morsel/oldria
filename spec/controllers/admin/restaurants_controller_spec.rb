require_relative '../../spec_helper'

describe Admin::RestaurantsController do
  integrate_views
  before do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
  end

  describe "GET index" do
    before do
      @restaurants = [FactoryGirl.create(:restaurant, :name => "Jims")]
      Restaurant.stubs(:find).returns(@restaurants)
      get :index
    end

    it "should be successful" do
      response.should be_success
    end

    it "should assign @restaurants" do
      assigns[:restaurants].should == @restaurants
    end

    it "should render index" do
      response.should render_template(:index)
    end

    it "should list @restaurants" do
      response.should contain("Jims")
    end
  end

  describe "GET edit" do
    before do
      @restaurant = FactoryGirl.create(:restaurant, :name => "HiLo")
      Restaurant.stubs(:find).returns(@restaurant)
      get :edit, :id => @restaurant.id
    end

    it { response.should be_success }
    it { response.should render_template(:edit) }

    it "should assign @restaurant" do
      assigns[:restaurant].should == @restaurant
    end
  end

  describe "PUT update" do
    before do
      @restaurant = FactoryGirl.create(:restaurant, :name => "HiLo")
      Restaurant.stubs(:find).returns(@restaurant)
    end

    context "when restaurant is valid" do
      before do
        @restaurant.stubs(:save).returns(true)
        put :update, :id => @restaurant.id, :restaurant => {}
      end

      it { response.should redirect_to(admin_restaurants_path) }

      it "should flash a notice message" do
        request.flash[:notice].should_not be_nil
      end
    end

    context "when restaurant is not valid" do
      before do
        @restaurant.stubs(:save).returns(false)
        put :update, :id => @restaurant.id, :restaurant => {}
      end

      it { response.should render_template(:edit) }

      it "should flash an error message" do
        request.flash[:error].should_not be_nil
      end
    end
  end

  describe "DELETE destroy" do
    before do
      @restaurant = FactoryGirl.create(:restaurant, :name => "What!")
      @restaurant.expects(:destroy).returns(@restaurant)
      Restaurant.stubs(:find).returns(@restaurant)
      delete :destroy, :id => @restaurant.id
    end

    it { response.should redirect_to(admin_restaurants_path)}
  end
end
