require_relative '../spec_helper'

describe AwardsController do
 integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    @profile = FactoryGirl.create(:profile,:user=>@user)
    @award = FactoryGirl.create(:award,:profile=>@profile)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET new" do
    it "assigns a new award as @award" do
      get :new,:user_id=>@user.id
      response.should render_template(:new)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      before(:each) do
        Award.stubs(:new).returns(@award)
        Award.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created award as @award" do
        post :create, :award => {},:user_id=>@user.id
        assigns[:award].should equal(@award)
      end

      it "redirects to the created award" do
        post :create, :award => {},:user_id=>@user.id
        response.should be_redirect
      end
    end
  end 

  describe "GET edit" do
    it "assigns the requested award as @award" do
      Award.stubs(:find).returns(@award)
      get :edit, :id => "37"
      assigns[:award].should equal(@award)
    end
  end

  describe "PUT update" do

    describe "with valid params" do
      before(:each) do
        Award.stubs(:find).returns(@award)
        Award.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested award" do
        Award.expects(:find).with("37").returns(@award)
        put :update, :id => "37", :award => {:these => 'params'}
      end

      it "assigns the requested award as @award" do
        Award.stubs(:find).returns(@award)
        put :update, :id => "1"
        assigns[:award].should equal(@award)
      end

      it "redirects to all award" do
        Award.stubs(:find).returns(@award)
        put :update, :id => "1"
        response.should be_redirect
      end
    end
  end 


end
