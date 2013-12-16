require_relative '../spec_helper'

describe ProfilesController do

  describe "editing and updating profiles" do

    before(:each) do
      fake_normal_user
      profile = FactoryGirl.create(:profile, :user => @user)
      @user.stubs(:profile).returns(profile)
      User.stubs(:find).returns(@user)
    end

    it "edit action should render edit template" do
      get :edit, :user_id => @user.id
      response.should render_template(:edit)
    end

    it "update action should render edit template when model is invalid" do
      Profile.any_instance.stubs(:valid?).returns(false)
      put :update, :user_id => @user.id
      response.should render_template(:edit)
    end

    it "update action should redirect when model is valid" do
      Profile.any_instance.stubs(:valid?).returns(true)
      put :update, :user_id => @user.id
      response.should redirect_to( edit_user_profile_path(:user_id => @user.id, :anchor => "profile-summary") )
    end

    it "should set the primary employment" do
      employment = FactoryGirl.create(:employment, :employee => @user)
      employment2 = FactoryGirl.create(:employment, :employee => @user)
      put :update, :user_id => @user.id, :profile => { :primary_employment => [employment2.id.to_s] }
      @user.primary_employment.should == employment2
    end

    it "should clear an old primary employment" do
      employment = FactoryGirl.create(:employment, :employee => @user)
      employment2 = FactoryGirl.create(:employment, :employee => @user, :primary => true)
      put :update, :user_id => @user.id, :profile => { :primary_employment => [employment.id.to_s] }
      @user.primary_employment.should == employment
      Employment.find(employment2.id).primary.should == false
    end

  end

  describe "creating a new profile" do

    before(:each) do
      fake_normal_user
      User.stubs(:find).returns(@user)
    end

    it "should set the primary employment when creating a new profile" do
      employment = FactoryGirl.create(:employment, :employee => @user)
      employment2 = FactoryGirl.create(:employment, :employee => @user)
      post :create, :user_id => @user.id, :profile => { :primary_employment => [employment.id.to_s] }
      @user.primary_employment.should == employment
    end

  end
end
