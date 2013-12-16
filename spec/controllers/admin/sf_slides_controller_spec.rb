require_relative '../../spec_helper'

describe Admin::SfSlidesController do

  before(:each) do
    @user = FactoryGirl.create(:admin)
    controller.stubs(:current_user).returns(@user)    
  end

  it "should list spoonfeed slides" do
    get :index
    assigns[:slides].should_not be_nil
  end
  
  it "should let an admin create a new slide" do
    slide = FactoryGirl.build(:sf_slide)
    SfSlide.expects(:new).returns(slide)
    slide.expects(:save).returns(true)
    post :create, :sf_slide => { :title => "New title", :excerpt => "Four-score and something something", 
      :link => "http://test.com" }
    response.should be_redirect
  end
  
  it "should let an admin update a slide" do
    slide = FactoryGirl.create(:sf_slide)
    SfSlide.expects(:find).returns(slide)
    slide.expects(:update_attributes).returns(true)
    put :update, :id => slide.id, :sf_slide => { :link => "http://bettertest.com" }
  end

end
