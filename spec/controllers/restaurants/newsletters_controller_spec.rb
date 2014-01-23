require_relative '../../spec_helper'

describe Restaurants::NewslettersController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    @restaurant = FactoryGirl.create(:restaurant, :manager => @user)
    @restaurant_newsletter = FactoryGirl.create(:restaurant_newsletter, :restaurant => @restaurant)
  end

  describe "GET index" do
    it "assigns all restaurant_newsletters as @restaurant_newsletter" do
      RestaurantNewsletter.stubs(:find).returns([@restaurant_newsletter])
      get :index, :restaurant_id => @restaurant.id
      expect(response).to render_template("restaurants/_comming_soon")
    end
  end

  describe "POST create" do

    describe "with valid params" do
      before(:each) do
        RestaurantNewsletter.stubs(:new).returns(@restaurant_newsletter)
        RestaurantNewsletter.any_instance.stubs(:save).returns(true)
      end
      it "redirects to the created restaurant_newsletter" do
        post :create, :restaurant_newsletter => {}, :restaurant_id => @restaurant.id
        response.should redirect_to :action => :show,
                                 :id => @restaurant_newsletter.id
      end
    end  
  end   
	  describe "with invalid params" do
	    before(:each) do
	      RestaurantNewsletter.any_instance.stubs(:save).returns(false)
	      RestaurantNewsletter.stubs(:new).returns(@restaurant_newsletter)
	    end

	    it "re-renders the 'new' template" do
	      post :create, :page => {}, :restaurant_id => @restaurant.id
	      response.should redirect_to :action => :show,
                                 :id => @restaurant_newsletter.id
	    end
	  end  

 describe "PUT update" do

    describe "with valid params" do
      before(:each) do
        RestaurantNewsletter.stubs(:find).returns(@restaurant)
        RestaurantNewsletter.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested restaurant" do
        RestaurantNewsletter.expects(:find).with("37").returns(@restaurant)
        put :update, :id => "37", :restaurant_id => @restaurant.id
      end

      it "redirects to all restaurant" do
        RestaurantNewsletter.stubs(:find).returns(@restaurant)
        put :update, :id => "1", :restaurant_id => @restaurant.id
        response.should redirect_to :action => :index,
                                 :restaurant => @restaurant
      end
    end

    describe "with invalid params" do
      before(:each) do
        RestaurantNewsletter.stubs(:find).returns(@restaurant)
        RestaurantNewsletter.any_instance.stubs(:update_attributes).returns(false)
      end

      it "updates the requested restaurant" do
        RestaurantNewsletter.expects(:find).with("37").returns(@restaurant)
        put :update, :id => "37", :restaurant_id => @restaurant.id
      end

      it "re-renders the 'index' template" do
        RestaurantNewsletter.stubs(:find).returns(@restaurant)
        put :update, :id => "1", :restaurant_id => @restaurant.id
        response.should redirect_to :action => :index,
                                 :restaurant => @restaurant
      end
    end
  end
 
  describe "GET show" do
    it "assigns all show as @show" do
      RestaurantNewsletter.stubs(:find).returns([@restaurant_newsletter])
      get :show, :restaurant_id => @restaurant.id,:id=>@restaurant_newsletter.id
      expect(response).to render_template("show")

    end
  end


  describe "GET preview" do
    it "assigns all preview as @preview" do
      RestaurantNewsletter.stubs(:find).returns([@restaurant_newsletter])
      get :preview, :restaurant_id => @restaurant.id
      response.should render_template :show 
    end
  end

  describe "GET approve" do
    it "assigns all approve as @approve" do
      RestaurantNewsletter.stubs(:find).returns([@restaurant_newsletter])
      get :approve, :restaurant_id => @restaurant.id
      response.should redirect_to(restaurant_newsletters_path(@restaurant.id)) 
    end
  end

  describe "GET disapprove" do
    it "assigns all disapprove as @disapprove" do
      RestaurantNewsletter.stubs(:find).returns([@restaurant_newsletter])
      get :disapprove, :restaurant_id => @restaurant.id
      response.should redirect_to(restaurant_newsletters_path(@restaurant.id)) 
    end
  end

  describe "GET archives" do
    it "assigns all archives as @archives" do
      get :archives, :restaurant_id => @restaurant.id
      expect(response).to render_template("restaurants/_comming_soon")
    end
  end

  describe "GET get_campaign_status" do
    it "assigns all get_campaign_status as @get_campaign_status" do
      get :get_campaign_status, :restaurant_id => @restaurant.id
      expect(response).to render_template("restaurants/_comming_soon")
    end
  end

  describe "GET get_opened_campaign" do
    it "assigns all get_opened_campaign as @get_opened_campaign" do
      get :get_opened_campaign, :restaurant_id => @restaurant.id
      expect { get :get_opened_campaign }.to_not render_template(layout: "application")
    end
  end

  describe "GET get_clicked_campaign" do
    it "assigns all get_clicked_campaign as @get_clicked_campaign" do
      get :get_clicked_campaign, :restaurant_id => @restaurant.id
      expect { get :get_clicked_campaign }.to_not render_template(layout: "application")
    end
  end

  describe "GET get_bounces_campaign" do
    it "assigns all get_bounces_campaign as @get_bounces_campaign" do
      get :get_bounces_campaign, :restaurant_id => @restaurant.id
      expect { get :get_bounces_campaign }.to_not render_template(layout: "application")
    end
  end  

end
