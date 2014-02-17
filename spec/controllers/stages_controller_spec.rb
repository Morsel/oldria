require_relative '../spec_helper'

describe StagesController do

  before(:each) do
    current_user = FactoryGirl.create(:user)
    @user = current_user
    controller.stubs(:current_user).returns current_user
    @profile = FactoryGirl.create(:profile, :user => current_user)
    @stage = FactoryGirl.create(:stage, :profile_id => @profile.id,:establishment => "House of Experts", :expert => "Top Expert", :start_date => 2.years.ago)
  end

   it "should build a new nonculinary stage" do
    get :new, :user_id => @user.id
    response.should be_success
    assigns[:stage].should_not be_nil
  end  

   it "should create a new stage" do
      stage = FactoryGirl.attributes_for(:stage, :profile => @user.profile)
      post :create, :user_id => @user.id, :stage => stage
      response.should be_redirect
    end

    it "should allow the user to edit a stage" do
      stage = FactoryGirl.create(:stage, :profile => @user.profile)
      get :edit, :user_id => @user.id, :id => stage.id
      response.should be_success
    end

    it "should update a stage" do
      stage = FactoryGirl.create(:stage, :profile => @user.profile)
      put :update, :user_id => @user.id, :id => stage.id
      response.should be_redirect
    end

    it "should delete a stage" do
      stage = FactoryGirl.create(:stage, :profile => @user.profile)
      delete :destroy, :user_id => @user.id, :id => stage.id
    end
end
