require_relative '../../spec_helper'

describe Admin::SoapboxSlidesController do
  
  before(:each) do
    @soapbox_slide = FactoryGirl.create(:soapbox_slide)
    @user = FactoryGirl.create(:admin)
    controller.stubs(:current_user).returns(@user)    
  end

  describe "GET index" do
    it "assigns all soapbox_slide as @soapbox_slide" do
      SoapboxSlide.stubs(:find).returns([@soapbox_slide])
      get :index
      assigns[:slides].should == [@soapbox_slide]
    end
  end

  describe "GET new" do
    it "assigns a new soapbox_slide as @soapbox_slide" do
      SoapboxSlide.stubs(:new).returns(@soapbox_slide)
      get :new
      assigns[:slide].should equal(@soapbox_slide)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      before(:each) do
        SoapboxSlide.stubs(:new).returns(@soapbox_slide)
        SoapboxSlide.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created soapbox_slide as @soapbox_slide" do
        post :create, :slide => {}
        assigns[:slide].should equal(@soapbox_slide)
      end

      it "redirects to the created soapbox_slide" do
        post :create, :slide => {}
         response.should redirect_to :action => :index
      end
    end
  end 

  describe "PUT update" do

    describe "with valid params" do
      before(:each) do
        SoapboxSlide.stubs(:find).returns(@soapbox_slide)
        SoapboxSlide.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested soapbox_slide" do
        SoapboxSlide.expects(:find).with("37").returns(@soapbox_slide)
        put :update, :id => "37", :soapbox_slide => {:these => 'params'}
      end

      it "assigns the requested soapbox_slide as @soapbox_slide" do
        SoapboxSlide.stubs(:find).returns(@soapbox_slide)
        put :update, :id => "1"
        assigns[:slide].should equal(@soapbox_slide)
      end

      it "redirects to all soapbox_slide" do
        SoapboxSlide.stubs(:find).returns(@soapbox_slide)
        put :update, :id => "1"
        response.should redirect_to :action => :index
      end
    end
  end 

  describe "DELETE destroy" do
    it "destroys the requested soapbox_slide" do
      SoapboxSlide.expects(:find).with("37").returns(@soapbox_slide)
      @soapbox_slide.expects(:destroy)
      delete :destroy, :id => "37"
      response.should redirect_to :action => :index
    end
  end

  it "destroys the requested soapbox_slide" do
    get  :sort
    response.should be_success
  end




end
