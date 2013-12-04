require_relative '../spec_helper'

describe Admin::CuisinesController do
  integrate_views

  before(:each) do
    @cuisine = Factory.stub(:cuisine)
    @user = Factory.stub(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "assigns all cuisines as @cuisines" do
      Cuisine.stubs(:find).returns([@cuisine])
      get :index
      assigns[:cuisines].should == [@cuisine]
    end
  end

  describe "GET new" do
    it "assigns a new cuisine as @cuisine" do
      Cuisine.stubs(:new).returns(@cuisine)
      get :new
      assigns[:cuisine].should equal(@cuisine)
    end
  end

  describe "GET edit" do
    it "assigns the requested cuisine as @cuisine" do
      Cuisine.stubs(:find).returns(@cuisine)
      get :edit, :id => "37"
      assigns[:cuisine].should equal(@cuisine)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      before(:each) do
        Cuisine.stubs(:new).returns(@cuisine)
        Cuisine.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created cuisine as @cuisine" do
        post :create, :cuisine => {}
        assigns[:cuisine].should equal(@cuisine)
      end

      it "redirects to the created cuisine" do
        post :create, :cuisine => {}
        response.should redirect_to(admin_cuisines_url)
      end
    end

    describe "with invalid params" do
      before(:each) do
        Cuisine.any_instance.stubs(:save).returns(false)
        Cuisine.stubs(:new).returns(@cuisine)
      end

      it "assigns a newly created but unsaved cuisine as @cuisine" do
        post :create, :cuisine => {:these => 'params'}
        assigns[:cuisine].should equal(@cuisine)
      end

      it "re-renders the 'new' template" do
        post :create, :cuisine => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      before(:each) do
        Cuisine.stubs(:find).returns(@cuisine)
        Cuisine.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested cuisine" do
        Cuisine.expects(:find).with("37").returns(@cuisine)
        put :update, :id => "37", :cuisine => {:these => 'params'}
      end

      it "assigns the requested cuisine as @cuisine" do
        Cuisine.stubs(:find).returns(@cuisine)
        put :update, :id => "1"
        assigns[:cuisine].should equal(@cuisine)
      end

      it "redirects to all cuisines" do
        Cuisine.stubs(:find).returns(@cuisine)
        put :update, :id => "1"
        response.should redirect_to(admin_cuisines_url)
      end
    end

    describe "with invalid params" do
      before(:each) do
        Cuisine.stubs(:find).returns(@cuisine)
        Cuisine.any_instance.stubs(:update_attributes).returns(false)
      end

      it "updates the requested cuisine" do
        Cuisine.expects(:find).with("37").returns(@cuisine)
        put :update, :id => "37", :cuisine => {:these => 'params'}
      end

      it "assigns the cuisine as @cuisine" do
        put :update, :id => "1"
        assigns[:cuisine].should equal(@cuisine)
      end

      it "re-renders the 'edit' template" do
        Cuisine.stubs(:find).returns(@cuisine)
        put :update, :id => "1"
        response.should render_template(:edit)
      end
    end
  end
end
