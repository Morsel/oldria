require_relative '../spec_helper'

describe CookbooksController do
  #integrate_views

  before(:each) do
    @cookbook = FactoryGirl.create(:cookbook)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end


   describe "GET new" do
    it "assigns a new cookbook as @cookbook" do
      @profile= FactoryGirl.create(:profile,:user_id=>@user.id)
      Cookbook.stubs(:new).returns(@profile.cookbooks)
    end
  end


end

