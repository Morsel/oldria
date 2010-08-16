require 'spec_helper'

describe ProfilesController do
  integrate_views
  before(:each) do
    fake_normal_user
  end

  it "edit action should render edit template" do
    get :edit
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    Profile.any_instance.stubs(:valid?).returns(false)
    put :update
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Profile.any_instance.stubs(:valid?).returns(true)
    put :update
    response.should redirect_to( profile_path(@user.username) )
  end
end
