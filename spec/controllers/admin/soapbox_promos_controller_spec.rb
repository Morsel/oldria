require_relative '../../spec_helper'

describe Admin::SoapboxPromosController do

  before(:each) do
    @soapbox_promo = FactoryGirl.create(:soapbox_promo)
    @user = FactoryGirl.create(:admin)
    controller.stubs(:current_user).returns(@user)    
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
      assigns[:promos].should_not be_nil
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
      assigns[:promo].should_not be_nil
    end
  end

  describe "POST create" do

    describe "with valid params" do
      before(:each) do
        SoapboxPromo.stubs(:new).returns(@soapbox_promo)
        SoapboxPromo.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created soapbox_promo as @soapbox_promo" do
        post :create, :promo => {}
        assigns[:promo].should equal(@soapbox_promo)
      end

      it "redirects to the created soapbox_promo" do
        post :create, :promo => {}
        response.should redirect_to :action => :index
      end
    end
  end   

  describe "PUT update" do

    describe "with valid params" do
      before(:each) do
        SoapboxPromo.stubs(:find).returns(@soapbox_promo)
        SoapboxPromo.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested soapbox_promo" do
        SoapboxPromo.expects(:find).with("37").returns(@soapbox_promo)
        put :update, :id => "37", :promo => {:these => 'params'}
      end

      it "assigns the requested soapbox_promo as @soapbox_promo" do
        SoapboxPromo.stubs(:find).returns(@soapbox_promo)
        put :update, :id => "1"
        assigns[:promo].should equal(@soapbox_promo)
      end

      it "redirects to all soapbox_promo" do
        SoapboxPromo.stubs(:find).returns(@soapbox_promo)
        put :update, :id => "1"
        response.should redirect_to :action => :index
      end
    end
  end   

  describe "DELETE destroy" do
    it "destroys the requested soapbox_promo" do
      SoapboxPromo.expects(:find).with("37").returns(@soapbox_promo)
      @soapbox_promo.expects(:destroy)
      delete :destroy, :id => "37"
      response.should redirect_to :action => :index
    end
  end

  it "destroys the requested soapbox_promo" do
    get  :sort
    response.should be_success
  end

end
