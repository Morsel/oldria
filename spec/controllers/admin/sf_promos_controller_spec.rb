require_relative '../../spec_helper'

describe Admin::SfPromosController do

  before(:each) do
    @sf_promo = FactoryGirl.create(:sf_promo)
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

   describe "POST create" do

    describe "with valid params" do
      before(:each) do
        SfPromo.stubs(:new).returns(@sf_promo)
        SfPromo.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created sf_promo as @sf_promo" do
        post :create, :sf_promo => {}
        assigns[:promo].should equal(@sf_promo)
      end

      it "redirects to the created sf_promo" do
        post :create, :sf_promo => {}
        response.should render_template(:action=> "index")
      end
    end
   describe "with invalid params" do
    before(:each) do
      SfPromo.any_instance.stubs(:save).returns(false)
      SfPromo.stubs(:new).returns(@sf_promo)
    end

    it "assigns a newly created but unsaved sf_promo as @sf_promo" do
      post :create, :sf_promo => {:these => 'params'}
      assigns[:promo].should equal(@sf_promo)
    end

    it "re-renders the 'new' template" do
      post :create, :sf_promo => {}
      #response.should render_template(:action=> "new")
    end
  end
 end

  describe "PUT update" do

    describe "with valid params" do
      before(:each) do
        SfPromo.stubs(:find).returns(@sf_promo)
        SfPromo.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested sf_promo" do
        SfPromo.expects(:find).with("37").returns(@sf_promo)
        put :update, :id => "37", :promo => {:these => 'params'}
      end

      it "assigns the requested sf_promo as @sf_promo" do
        SfPromo.stubs(:find).returns(@sf_promo)
        put :update, :id => "1"
        assigns[:promo].should equal(@sf_promo)
      end

      it "redirects to all sf_promo" do
        SfPromo.stubs(:find).returns(@sf_promo)
        put :update, :id => "1"
         response.should redirect_to :action => :index
      end
    end

    describe "with invalid params" do
      before(:each) do
        SfPromo.stubs(:find).returns(@sf_promo)
        SfPromo.any_instance.stubs(:update_attributes).returns(false)
      end

      it "updates the requested sf_promo" do
        SfPromo.expects(:find).with("37").returns(@sf_promo)
        put :update, :id => "37", :promo => {:these => 'params'}
      end

      it "assigns the sf_promo as @sf_promo" do
        put :update, :id => "1"
        assigns[:promo].should equal(@sf_promo)
      end

      it "re-renders the 'edit' template" do
        SfPromo.stubs(:find).returns(@sf_promo)
        put :update, :id => "1"
        response.should render_template(:action=> "edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested sf_promo" do
      SfPromo.expects(:find).with("37").returns(@sf_promo)
      @sf_promo.expects(:destroy)
      delete :destroy, :id => "37"
       response.should redirect_to :action => :index
    end
  end   

  describe "get sort" do
    it "destroys the requested sf_promo" do
      post :sort
      response.should be_success
    end
  end   



end
