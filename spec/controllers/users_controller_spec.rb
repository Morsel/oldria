require 'spec/spec_helper'

describe UsersController do

  describe "GET index" do
    context "responding with js" do
      before(:each) do
        @john1 = Factory.stub(:user, :first_name => "John", :last_name => "Hamm")
        @john2 = Factory.stub(:user, :first_name => "John", :last_name => "Manner")
      end

      it "should return a list of found users, joined by newlines" do
        User.expects(:find_all_by_name).returns([@john1,@john2])
        get :index, :format => 'js', :q => "John"
        assigns[:users].should == [@john1, @john2]
        response.body.should contain("John Hamm")
        response.body.should contain("John Manner")
      end
    end
  end

  describe "GET new" do
    context "as an anonymous user" do
      before(:each) do
        # user =  Factory.stub(:user)
        # user.stubs(:has_role?).with(:media).returns(true)
        controller.stubs(:current_user).returns nil
      end
      it "should render new template" do
        get :new
        response.should render_template(:new)
      end
    end

    context "as a logged in user" do
      before(:each) do
        user =  Factory.stub(:user)
        user.stubs(:has_role?).returns(false)
        controller.stubs(:current_user).returns user
      end

      it "should redirect to the homepage" do
        get :new
        response.should redirect_to(root_url)
      end
    end
  end

  describe "GET show" do
    before(:each) do
      @user = Factory(:user, :id => 3)
      #User.stubs(:find).returns @user
    end

    context "as an anonymous user" do
      before(:each) do
        controller.stubs(:current_user).returns nil
      end
      it "should redirect to the login page" do
        get :show, :id => 3
        response.should redirect_to(login_url)
      end
    end

    context "as a logged in user" do
      before(:each) do
        current_user = Factory(:user)
        controller.stubs(:current_user).returns current_user
      end

      it "should render show" do
        get :show, :id => 3
        response.should render_template(:show)
      end
    end
  end

  describe "resending the confirmation email" do

    context "as an unconfirmed user" do

      it "should show the user a page to request a new email" do
        get :resend_confirmation
        response.should render_template("users/resend_confirmation")
      end

      it "should process a request to send a new email" do
        user = Factory(:user, :email => "foo@bar.com")
        UserMailer.expects(:deliver_signup).with(user)
        post :resend_confirmation, :email => "foo@bar.com"
        response.should be_redirect
      end

      it "should return an error message if the user's email can't be found" do
        post :resend_confirmation, :email => "fool@bar.com"
        response.should render_template("users/resend_confirmation")
        flash[:error].should_not be_nil
      end

    end

  end
  
  describe "profile visibility" do

    before(:each) do
      @current_user = Factory(:user)
      controller.stubs(:current_user).returns @current_user
    end    

    it "should allow a user to view another user's profile" do
      user = Factory(:user)
      get :show, :id => user.id
      response.should be_success
    end
    
    it "should not allow a user to view another person's unpublished profile" do
      user = Factory(:user, :prefers_publish_profile => false)
      get :show, :id => user.id
      response.should be_redirect
    end
    
    it "should allow a user to view their own unpublished profile" do
      @current_user.update_attribute(:prefers_publish_profile, false)
      get :show, :id => @current_user.id
      response.should be_success
    end
    
    it "should allow an admin to view any profile" do
      current_user = Factory(:admin)
      controller.stubs(:current_user).returns current_user
      
      user = Factory(:user, :prefers_publish_profile => false)
      get :show, :id => user.id
      
      response.should be_success
    end

  end

end
