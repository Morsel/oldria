require 'spec_helper'

describe Admin::SoapboxSlidesController do
  
  before(:each) do
    @user = Factory(:admin)
    controller.stubs(:current_user).returns(@user)    
  end

  it "should list current slides" do
    get :index
    assigns[:slides].should_not be_nil
  end
  
  it "should let an admin create a new slide" do
    slide = Factory.build(:soapbox_slide)
    SoapboxSlide.expects(:new).returns(slide)
    slide.expects(:save).returns(true)
    post :create, :soapbox_slide => { :title => "New title", :excerpt => "Four-score and something something", 
      :link => "http://test.com" }
    response.should be_redirect
  end

end
