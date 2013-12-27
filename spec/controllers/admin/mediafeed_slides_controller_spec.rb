require_relative '../../spec_helper'
describe Admin::MediafeedSlidesController do

  before(:each) do
    fake_admin_user
    FactoryGirl.create(:mediafeed_slide)
  end

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    MediafeedSlide.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end


end 	
