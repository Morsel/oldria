require_relative '../spec_helper'

describe AwardsController do
 integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET new" do
    it "assigns a new award as @award" do
    	@profile = FactoryGirl.create(:profile,:user=>@user)
      get :new,:user_id=>@user.id
      if request.xhr?
        expect { get :new }.to_not render_template(layout: "application")
      end   
    end
  end

  describe "POST create" do
	  it "create action should render new template when model is invalid" do
	  	@profile = FactoryGirl.create(:profile,:user=>@user)
	  	@award = FactoryGirl.create(:award,:profile=>@profile)
	    Award.any_instance.stubs(:valid?).returns(false)
	    post :create,:user_id=>@user.id
	    response.should render_template(:new)
	  end
	end   

  describe "GET edit" do
    it "edit nonculinary_enrollment as @nonculinary_enrollment" do
    	@profile = FactoryGirl.create(:profile,:user=>@user)
      get :new,:user_id=>@user.id,:id=>@profile.id
      if request.xhr?
        expect { get :edit }.to_not render_template(layout: "application")
      end   
    end
  end


end
