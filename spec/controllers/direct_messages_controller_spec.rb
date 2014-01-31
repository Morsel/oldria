require_relative '../spec_helper'

describe DirectMessagesController do
  integrate_views
  before(:all) do
    User.destroy_all
  end

  before(:each) do
    @sender = FactoryGirl.create(:user)
    @sender.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@sender)
    @receiver = FactoryGirl.create(:user, :username => 'getterboy')
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
        @dm = FactoryGirl.create(:direct_message, :receiver => @sender, :sender => @receiver)
        DirectMessage.stubs(:find).returns(@dm)
        @dm_params = FactoryGirl.attributes_for(:direct_message, :receiver => @receiver, :sender => @sender, :in_reply_to_message_id => '2')
      end
    end
  end

  it "should render show template" do
    @dm = FactoryGirl.create(:direct_message, :receiver => @sender, :sender => @receiver)
    get :show,:id=>@dm.id
    response.should render_template(:show)
  end

  it "should render " do
    @dm = FactoryGirl.create(:direct_message, :receiver => @sender, :sender => @receiver)
    get :show,:id=>@dm.id
    response.should be_success
  end


end
