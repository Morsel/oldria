require_relative '../../spec_helper'

describe Soapbox::SoapboxPasswordResetsController do
  integrate_views
  describe "create action" do
    it "Deliver password reset instruction and redirect to new action" do
      @newsletter_subscriber = FactoryGirl.create(:newsletter_subscriber)
      get :create,:email=>@newsletter_subscriber.email
      #response.should redirect_to( :action => 'new' )
    end
  end
 
end
