require_relative '../../spec_helper'

describe Admin::EmailStopwordsController do

  integrate_views

  before(:each) do
    @email_stopword = FactoryGirl.create(:email_stopword)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "assigns all email_stopword as @email_stopword" do
      Admin::EmailStopword.stubs(:find).returns([@email_stopword])
      get :index
      assigns[:stopwords].should == [@email_stopword]
      response.should render_template(:index)
    end
  end

  describe "GET new" do
    it "assigns a new email_stopword as @email_stopword" do
      Admin::EmailStopword.stubs(:new).returns(@email_stopword)
      get :new
      assigns[:stopword].should equal(@email_stopword)
      response.should render_template(:new)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      before(:each) do
        Admin::EmailStopword.stubs(:new).returns(@email_stopword)
        Admin::EmailStopword.any_instance.stubs(:save).returns(true)
      end

      it "redirects to the created email_stopword" do
        post :create, :admin_email_stopword => {}
         response.should redirect_to :action => :index
      end
    end

    describe "with invalid params" do
      before(:each) do
        Admin::EmailStopword.any_instance.stubs(:save).returns(false)
        Admin::EmailStopword.stubs(:new).returns(@email_stopword)
      end

      it "re-renders the 'index' template" do
        post :create, :email_stopword => {}
        response.should redirect_to :action => :index
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested email_stopword" do
       Admin::EmailStopword.expects(:find).with("37").returns(@email_stopword)
      @email_stopword.expects(:destroy)
      delete :destroy, :id => "37"
      response.should redirect_to :action => :index
    end
  end



end
