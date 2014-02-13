require_relative '../spec_helper'

describe EnrollmentsController do
  # integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    @enrollment =	FactoryGirl.create(:enrollment,:profile_id=>@user.id)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end
  
  it "new action should render new template" do
    get :new,:user_id=>@user.id
    response.should render_template(:new)
  end

  it "edit action should render edit template" do
    get :edit, :id => Enrollment.first
    response.should render_template(:edit)
  end

  it "create action should render new template when model is invalid" do
    Enrollment.any_instance.stubs(:valid?).returns(false)
    post :create,:user_id=>@user.id
    response.should render_template(:new)
  end


 
end
