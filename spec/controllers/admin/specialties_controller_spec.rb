require_relative '../../spec_helper'

describe Admin::SpecialtiesController do
  integrate_views

  before(:each) do
    @specialty = FactoryGirl.create(:specialty)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "assigns all specialty as @specialty" do
      Specialty.stubs(:find).returns([@specialty])
      get :index
      assigns[:specialties].should == [@specialty]
      response.should render_template(:index)
    end
  end

  describe "GET new" do
    it "assigns a new specialty as @specialty" do
      Specialty.stubs(:new).returns(@specialty)
      get :new
      assigns[:specialty].should equal(@specialty)
    end
  end

  describe "GET edit" do
    it "assigns the requested specialty as @specialty" do
      Specialty.stubs(:find).returns(@specialty)
      get :edit, :id => "37"
      assigns[:specialty].should equal(@specialty)
    end
  end

    describe "POST create" do

      describe "with valid params" do
        before(:each) do
          Specialty.stubs(:new).returns(@specialty)
          Specialty.any_instance.stubs(:save).returns(true)
        end

        it "assigns a newly created specialty as @specialty" do
          post :create, :specialty => {}
          assigns[:specialty].should equal(@specialty)
        end

        it "redirects to the created specialty" do
          post :create, :specialty => {}
          response.should redirect_to :action => :index
        end
      end

      describe "with invalid params" do
        before(:each) do
          Specialty.any_instance.stubs(:save).returns(false)
          Specialty.stubs(:new).returns(@specialty)
        end

        it "assigns a newly created but unsaved specialty as @specialty" do
          post :create, :specialty => {:these => 'params'}
          assigns[:specialty].should equal(@specialty)
        end

        it "re-renders the 'new' template" do
          post :create, :specialty => {}
          response.should render_template(:action=> "new")
        end
      end
    end

    describe "PUT update" do

      describe "with valid params" do
        before(:each) do
          Specialty.stubs(:find).returns(@specialty)
          Specialty.any_instance.stubs(:update_attributes).returns(true)
        end

        it "updates the requested specialty" do
          Specialty.expects(:find).with("37").returns(@specialty)
          put :update, :id => "37", :specialty => {:these => 'params'}
        end

        it "assigns the requested specialty as @specialty" do
          Specialty.stubs(:find).returns(@specialty)
          put :update, :id => "1"
          assigns[:specialty].should equal(@specialty)
        end

        it "redirects to all specialty" do
          Specialty.stubs(:find).returns(@specialty)
          put :update, :id => "1"
          response.should redirect_to :action => :index
        end
      end

      describe "with invalid params" do
        before(:each) do
          Specialty.stubs(:find).returns(@specialty)
          Specialty.any_instance.stubs(:update_attributes).returns(false)
        end

        it "updates the requested specialty" do
          Specialty.expects(:find).with("37").returns(@specialty)
          put :update, :id => "37", :specialty => {:these => 'params'}
        end

        it "assigns the specialty as @specialty" do
          put :update, :id => "1"
          assigns[:specialty].should equal(@specialty)
        end

        it "re-renders the 'edit' template" do
          Specialty.stubs(:find).returns(@specialty)
          put :update, :id => "1"
          response.should render_template(:action=> "edit")
        end
      end
    end

  describe "DELETE destroy" do
    it "destroys the requested specialty" do
      Specialty.expects(:find).with("37").returns(@specialty)
      @specialty.expects(:destroy)
      delete :destroy, :id => "37"
      response.should redirect_to :action => :index
    end
  end 

  describe "sort" do
    it "sort" do
      get :sort
      response.body.should be_blank
    end
  end 

end
