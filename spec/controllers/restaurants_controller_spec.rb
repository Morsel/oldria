require_relative '../spec_helper'

describe RestaurantsController do
  #integrate_views

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    @restaurant = FactoryGirl.create(:restaurant)
  end

  describe "GET index" do
    it "assigns all employments as @employments" do
      get :index
      assigns[:employments].should ==  @user.employments
      @request.env['HTTP_ACCEPT'] = 'text/javascript'
    end
  end

  describe "GET new" do
    it "assigns a new restaurant as @restaurant" do
      get :new
       response.should render_template(:new)
    end
  end

   describe "GET show" do
    it "work for show condition" do
      get :show,:id=>@restaurant.id
      response.should render_template(:show)
    end
  end

  it "select_primary_photo" do
    get :select_primary_photo, :id =>@restaurant.id
    response.should be_redirect
  end

  it "replace_media_contact" do
    get :replace_media_contact,:media_contact=>@restaurant.media_contact.id,:id=>@restaurant.id
    response.should be_redirect
  end

  it "replace_manager" do
    get :replace_manager,:id=>@restaurant.id
    response.should be_redirect
  end

  it "fb_page_auth" do
    get :fb_page_auth,:id=>@restaurant.id
    response.should be_redirect
  end

  it "fb_deauth" do
    get :fb_deauth,:id=>@restaurant.id
    response.should be_redirect
  end

  it "remove_twitter" do
    get :remove_twitter,:id=>@restaurant.id
    response.should be_redirect
  end  

  it "activate_restaurant" do
    get :activate_restaurant,:id=>@restaurant.id
    response.should be_redirect
  end  
 
  it "newsletter_subscriptions" do
    get :newsletter_subscriptions,:id=>@restaurant.id
    response.should be_redirect
  end

  it "download_subscribers" do
    get :download_subscribers,:id=>@restaurant.id
    response.should be_redirect
  end   

  it "add_restaurant" do
    get :add_restaurant,:id=>@restaurant.id
    response.should render_template(:add_restaurant)
  end     

  it "send_restaurant_request" do
    get :send_restaurant_request,:id=>@restaurant.id
    flash[:notice].should_not be_nil
    response.should redirect_to(root_path)
  end 

  it "restaurant_visitors" do
    get :restaurant_visitors,:id=>@restaurant.id
    response.should be_redirect
  end

  it "import_csv" do
    get :import_csv,:id=>@restaurant.id
    response.should be_redirect
  end

  it "media_subscribe" do
    get :media_subscribe,:id=>@restaurant.id
    response.should redirect_to :action => :show,
                                 :id => @restaurant.id
  end

  it "media_user_newsletter_subscription" do
    get :media_user_newsletter_subscription,:id=>@restaurant.id,:id=>@user.id
    expect { get :media_user_newsletter_subscription }.to_not render_template(layout: "application") 
    response.should render_template(:media_user_newsletter_subscription)                            
  end

  it "show_notice" do
    get :show_notice,:id=>@restaurant.id,:restaurant_id=>@restaurant.id
    response.should render_template(:show_notice)                            
  end

  it "auto_complete_restaurantkeywords" do
    get :auto_complete_restaurantkeywords,:id=>@restaurant.id,:term=>@restaurant.name
    @request.env['HTTP_ACCEPT'] = 'text/javascript'
    response.should be_success                           
  end

  it "request_profile_update" do
    get :request_profile_update,:id=>@restaurant.id,:restaurant_id=>@restaurant.id
    flash[:notice].should_not be_nil
    response.should redirect_to(restaurant_path(@restaurant))            
  end
  
  it "confirmation_screen" do
    get :confirmation_screen,:id=>@restaurant.id,:restaurant_id=>@restaurant.id
    response.should be_redirect
  end


end
