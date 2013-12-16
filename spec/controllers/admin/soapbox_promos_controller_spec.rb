require_relative '../../spec_helper'

describe Admin::SoapboxPromosController do

  before(:each) do
    @user = FactoryGirl.create(:admin)
    controller.stubs(:current_user).returns(@user)    
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
      assigns[:promos].should_not be_nil
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
      assigns[:promo].should_not be_nil
    end
  end

end
