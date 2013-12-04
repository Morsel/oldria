require_relative '../spec_helper'

describe DirectMessagesController do
  integrate_views
  before(:all) do
    User.destroy_all
  end

  before(:each) do
    @sender = Factory(:user)
    @sender.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@sender)
    @receiver = Factory(:user, :username => 'getterboy')
  end

  describe "GET new" do
    it "should render new template" do
      get :new, :user_id => @receiver.id
      response.should render_template(:new)
    end
  end

  describe "POST create" do
    it "should render new template when model is invalid" do
      DirectMessage.any_instance.stubs(:valid?).returns(false)
      post :create, :direct_message => {}, :user_id => @receiver.id
      response.should render_template(:new)
    end

    it "should redirect when model is saved successfully" do
      @sender.sent_direct_messages.stubs(:build).returns(message = Factory(:direct_message))
      DirectMessage.any_instance.stubs(:save).returns(true)
      post :create, :direct_message => {}, :user_id => @receiver.id
      response.should redirect_to(direct_message_path(message))
    end

    it "should assign @recipient" do
      post :create, :direct_message => {}, :user_id => @receiver.id
      assigns[:recipient].should == @receiver
    end

    it "should assign @direct_message with @recipient set as receiver" do
      post :create, :direct_message => {}, :user_id => @receiver.id
      assigns[:direct_message].receiver.should == @receiver
    end

    describe "when the direct message is a reply" do
      before(:each) do
        @dm = Factory.stub(:direct_message, :receiver => @sender, :sender => @receiver)
        DirectMessage.stubs(:find).returns(@dm)
        @dm_params = Factory.attributes_for(:direct_message, :receiver => @receiver, :sender => @sender, :in_reply_to_message_id => '2')
      end

      it "should handle in_reply_to_message_id" do
        post :create, :direct_message => @dm_params, :user_id => @receiver.id
        assigns[:direct_message].parent_message.should_not be_nil
      end
    end
  end

end
