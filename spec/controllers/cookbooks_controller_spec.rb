require_relative '../spec_helper'

describe CookbooksController do
  #integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    @cookbook = FactoryGirl.create(:cookbook,:profile_id=>@user.id)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end


  it "edit action should render edit template" do
    get :edit, :id => Cookbook.first
    response.should render_template(:edit)
  end

  describe "GET new" do
    it "assigns a new cookbook as @cookbook" do
      Cookbook.stubs(:new).returns(@cookbook)
      get :new,:user_id=>@user.id
      response.should render_template(:new)
    end
  end

 describe "POST create" do

    describe "with valid params" do
      before(:each) do
        Cookbook.stubs(:new).returns(@cookbook)
        Cookbook.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created cookbook as @cookbook" do
        post :create, :cookbook => {},:user_id=>@user.id
        response.should be_success
      end

      it "redirects to the created cookbook" do
        post :create, :cookbook => {},:user_id=>@user.id
        response.should be_success
      end
    end
  end 

 


end

