require_relative '../../spec_helper'

describe Admin::DirectMessagesController do
  before(:each) do
    @direct_message = FactoryGirl.create(:direct_message)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
  end

  describe "GET index" do
    it "assigns all direct_messages as @direct_messages" do
      proxy = [@direct_message]
      proxy.stubs(:all).returns(proxy)
      DirectMessage.expects(:all_from_admin).returns(proxy)
      get :index
      assigns[:direct_messages].should == [@direct_message]
    end
  end

  describe "GET show" do
    it "assigns the requested direct_message as @direct_message" do
      DirectMessage.stubs(:find).with("37").returns(@direct_message)
      get :show, :id => "37"
      assigns[:direct_message].should equal(@direct_message)
    end
  end

  describe "GET new" do
    it "assigns a new direct_message as @direct_message" do
      DirectMessage.stubs(:new).returns(@direct_message)
      get :new
      assigns[:direct_message].should equal(@direct_message)
      assigns[:direct_message].should be_from_admin
    end
  end

  describe "GET edit" do
    it "assigns the requested direct_message as @direct_message" do
      DirectMessage.stubs(:find).with("37").returns(@direct_message)
      get :edit, :id => "37"
      assigns[:direct_message].should equal(@direct_message)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created direct_message as @direct_message" do
        DirectMessage.stubs(:new).returns(@direct_message)
        post :create, :direct_message => {:body => 'This is a message'}
        assigns[:direct_message].should equal(@direct_message)
        assigns[:direct_message].should be_from_admin
      end

      it "redirects to the created direct_message" do
        DirectMessage.stubs(:new).returns(@direct_message)
        post :create, :direct_message => {}
        response.should redirect_to(admin_direct_messages_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved direct_message as @direct_message" do
        DirectMessage.stubs(:new).returns(@direct_message)
        @direct_message.stubs(:valid?).returns(false)
        post :create, :direct_message => {:body => 'This is a message'}
        assigns[:direct_message].should equal(@direct_message)
      end

      it "re-renders the 'new' template" do
        DirectMessage.stubs(:new).returns(@direct_message)
        @direct_message.stubs(:valid?).returns(false)
        post :create, :direct_message => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested direct_message" do
        DirectMessage.expects(:find).with("37").returns(@direct_message)
        @direct_message.expects(:update_attributes).with({'body' => 'params'})
        put :update, :id => "37", :direct_message => {:body => 'params'}
      end

      it "assigns the requested direct_message as @direct_message" do
        DirectMessage.stubs(:find).returns(@direct_message)
        put :update, :id => "1"
        assigns[:direct_message].should equal(@direct_message)
      end

      it "redirects to direct_messages" do
        DirectMessage.stubs(:find).returns(@direct_message)
        put :update, :id => "1"
        response.should redirect_to(admin_direct_messages_url)
      end
    end

    describe "with invalid params" do
      before(:each) do
        @direct_message.stubs(:valid?).returns(false)
      end

      it "updates the requested direct_message" do
        DirectMessage.expects(:find).with("37").returns(@direct_message)
        @direct_message.expects(:update_attributes).with({'body' => 'params'})
        put :update, :id => "37", :direct_message => {:body => 'params'}
      end

      it "assigns the direct_message as @direct_message" do
        DirectMessage.stubs(:find).returns(@direct_message)
        put :update, :id => "1"
        assigns[:direct_message].should equal(@direct_message)
      end

      it "re-renders the 'edit' template" do
        DirectMessage.stubs(:find).returns(@direct_message)
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested direct_message" do
      DirectMessage.expects(:find).with("37").returns(@direct_message)
      @direct_message.expects(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the admin_direct_messages list" do
      DirectMessage.stubs(:find).returns(@direct_message)
      delete :destroy, :id => "1"
      response.should redirect_to(admin_direct_messages_url)
    end
  end
end
