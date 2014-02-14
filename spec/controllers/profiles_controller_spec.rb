require_relative '../spec_helper'

describe ProfilesController do
  integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @profile = FactoryGirl.create(:profile,:user_id=>@user.id)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "POST create" do

    describe "with valid params" do
      before(:each) do
        Profile.stubs(:new).returns(@profile)
        Profile.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created profile as @profile" do
        post :create, :profile => {}, :user_id => @user.id
        assigns[:profile].should equal(@profile)
      end

      it "redirects to the created profile" do
        post :create, :profile => {}, :user_id => @user.id
        response.should be_redirect
      end
    end

    describe "with invalid params" do
      before(:each) do
        Profile.any_instance.stubs(:save).returns(false)
        Profile.stubs(:new).returns(@profile)
      end

      it "assigns a newly created but unsaved profile as @profile" do
        post :create, :profile => {:these => 'params'}, :user_id => @user.id
        assigns[:profile].should equal(@profile)
      end
    end
  end

  it "edit action should render edit template" do
    get :edit, :id => Profile.first, :user_id => @user.id
    response.should render_template(:edit)
  end

  it "edit_btl" do
    get :edit_btl, :id => Profile.first, :user_id => @user.id
    response.should be_success
  end

  it "edit_front_burner" do
    get :edit_front_burner, :id => Profile.first, :user_id => @user.id
    response.should be_success
  end
  
  it "toggle_publish_profile" do
    get :toggle_publish_profile, :user_id => @user.id
    response.should be_success
  end

  it "add_role_form" do
    get :add_role_form, :user_id => @user.id
    response.should be_success
  end

  it "save_cusines" do
    get :save_cusines, :user_id => @user.id
    response.should be_success
  end
end
