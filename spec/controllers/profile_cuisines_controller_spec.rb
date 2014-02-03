require_relative '../spec_helper'

describe ProfileCuisinesController do
  before(:each) do
    @user = FactoryGirl.create(:admin)
    @profile_cuisine = FactoryGirl.create(:profile_cuisine,:profile_id=>@user.id)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end


  it "new action should render new template" do
    get :new,:user_id=>@user.id
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    ProfileCuisine.any_instance.stubs(:valid?).returns(false)
    post :create,:user_id=>@user.id
    response.should render_template(:new)
  end

end
