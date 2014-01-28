require_relative '../../spec_helper'

describe Soapbox::SoapboxPasswordResetsController do
  integrate_views
 


  describe "create action for if condition" do
    it "Deliver password reset instruction and redirect to new action" do
      @newsletter_subscriber = FactoryGirl.create(:newsletter_subscriber)
      get :create,:email=>@newsletter_subscriber.email
      flash.should_not be_nil
      response.should redirect_to :action => :new
    end
    it "Deliver password reset instruction and render to new action" do
      get :create
      flash.should_not be_nil
      response.should render_template(:action=> "new")
    end
  end
 
  describe "resend_confirmation for if condition" do
    it "Deliver password reset instruction and redirect admin_users_url path" do
      @newsletter_subscriber = FactoryGirl.create(:newsletter_subscriber)
      post :resend_confirmation,:email=>@newsletter_subscriber.email
      flash.should_not be_nil
      response.should redirect_to(root_path)
    end
  end
 

end
