require_relative '../spec_helper'

describe AccoladesController do
  integrate_views

  before(:each) do
    @profile = FactoryGirl.create(:profile)
    @accolade = FactoryGirl.create(:accolade, :accoladable => @profile)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET new" do
    it "assigns all new accolade as @accolade" do
      Accolade.stubs(:find).returns([@accolade])
      get :new
      response.should be_success
    end
  end

  describe "POST create" do

    describe "with valid params" do
      before(:each) do
        Accolade.stubs(:new).returns(@accolade)
        Accolade.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created accolade as @accolade" do
        post :create, :accolade => {}
        response.should be_success
      end

      it "redirects " do
        post :create, :accolade => {}
        response.should be_success
      end
    end
  end 
  
  it "edit action should render edit template" do
    get :edit, :id => Accolade.first
    response.should be_success
  end


end 


