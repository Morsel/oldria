require_relative '../../spec_helper'
describe Admin::MediafeedSlidesController do

  before(:each) do
    fake_admin_user
    #FactoryGirl.create(:mediafeed_slide)
    @mediafeed_slide = FactoryGirl.create(:mediafeed_slide)
  end

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "sort" do
    get :sort
    response.should be_success
  end

  describe "POST create" do

    describe "with valid params" do
      before(:each) do
        MediafeedSlide.stubs(:new).returns(@mediafeed_slide)
        MediafeedSlide.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created mediafeed_slide as @mediafeed_slide" do
        post :create, :mediafeed_slide => {}
        assigns[:slide].should equal(@mediafeed_slide)
      end

      it "redirects to the created mediafeed_slide" do
        post :create, :mediafeed_slide => {}
        response.should redirect_to :action => :index
      end
    end

    describe "with invalid params" do
      before(:each) do
        MediafeedSlide.any_instance.stubs(:save).returns(false)
        MediafeedSlide.stubs(:new).returns(@mediafeed_slide)
      end

      it "assigns a newly created but unsaved mediafeed_slide as @mediafeed_slide" do
        post :create, :mediafeed_slide => {:these => 'params'}
        assigns[:slide].should equal(@mediafeed_slide)
      end

      it "re-renders the 'new' template" do
        post :create, :mediafeed_slide => {}
        response.should render_template(:action=> "new")
      end
    end
  end 

  describe "GET edit" do
    it "assigns the requested mediafeed_slide as @mediafeed_slide" do
      MediafeedSlide.stubs(:find).returns(@mediafeed_slide)
      get :edit, :id => "37"
      assigns[:slide].should equal(@mediafeed_slide)
    end
  end

  describe "PUT update" do

    describe "with valid params" do
      before(:each) do
        MediafeedSlide.stubs(:find).returns(@mediafeed_slide)
        MediafeedSlide.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested mediafeed_slide" do
        MediafeedSlide.expects(:find).with("37").returns(@mediafeed_slide)
        put :update, :id => "37", :mediafeed_slide => {:these => 'params'}
      end

      it "assigns the requested mediafeed_slide as @mediafeed_slide" do
        MediafeedSlide.stubs(:find).returns(@mediafeed_slide)
        put :update, :id => "1"
        assigns[:slide].should equal(@mediafeed_slide)
      end

      it "redirects to all mediafeed_slide" do
        MediafeedSlide.stubs(:find).returns(@mediafeed_slide)
        put :update, :id => "1"
        response.should render_template(:action=> "index")
      end
    end

    describe "with invalid params" do
      before(:each) do
        MediafeedSlide.stubs(:find).returns(@mediafeed_slide)
        MediafeedSlide.any_instance.stubs(:update_attributes).returns(false)
      end

      it "updates the requested mediafeed_slide" do
        MediafeedSlide.expects(:find).with("37").returns(@mediafeed_slide)
        put :update, :id => "37", :mediafeed_slide => {:these => 'params'}
      end

      it "assigns the mediafeed_slide as @mediafeed_slide" do
        put :update, :id => "1"
        assigns[:slide].should equal(@mediafeed_slide)
      end

      it "re-renders the 'edit' template" do
        MediafeedSlide.stubs(:find).returns(@mediafeed_slide)
        put :update, :id => "1"
        response.should render_template(:action=> "edit")
      end
    end
  end








end 	
