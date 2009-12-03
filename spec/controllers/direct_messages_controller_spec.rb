require 'spec/spec_helper'

describe DirectMessagesController do
  integrate_views
  before(:all) do
    User.destroy_all
  end

  before(:each) do
    @sender = Factory(:user)
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
      DirectMessage.any_instance.stubs(:save).returns(true)
      post :create, :direct_message => {}, :user_id => @receiver.id
      response.should redirect_to(root_url)
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

  describe "GET reply" do
    before(:each) do
      @dm = Factory.stub(:direct_message, :receiver => @sender, :sender => @receiver)
      DirectMessage.stubs(:find).returns(@dm)
      DirectMessage.any_instance.stubs(:build_reply).returns(
        Factory.stub(:direct_message, :receiver => @receiver, :sender => @sender, :in_reply_to_message_id => @dm.id)
      )
    end

    it "should render reply template" do
      get :reply, :id => @dm.id
      response.should render_template(:reply)
    end

    it "should assign @original_message" do
      get :reply, :id => @dm.id
      assigns[:original_message].should eql(@dm)
    end

    it "should assign @direct_message" do
      get :reply, :id => @dm.id
      assigns[:direct_message].should eql(@dm.build_reply)
    end

    it "should assign @recipient" do
      get :reply, :id => @dm.id
      assigns[:recipient].should eql(@dm.build_reply.receiver)
    end
    
    it "should not use a put request" do
      get :reply, :id => @dm.id
      response.should_not have_selector('input',
        :type => 'hidden',
        :name => '_method',
        :value => 'put'
      )
    end
    
    it "should require the current_user to be receiver of original message" do
      other_dm = Factory.stub(:direct_message, :sender => Factory.stub(:user, :username => 'randomuser'))
      DirectMessage.stubs(:find).returns(other_dm)
      get :reply, :id => other_dm.id
      response.should redirect_to(root_url)
      flash[:error].should contain("only reply to messages sent to you")
    end
    
    it "should have a hidden field with the value of original message id" do
      get :reply, :id => @dm.id
      response.should have_selector('form') do |form|
        form.should have_selector('input', 
          :type => 'hidden',
          :name => 'direct_message[in_reply_to_message_id]',
          :value => @dm.id.to_s
        )
      end
    end
  end

end
