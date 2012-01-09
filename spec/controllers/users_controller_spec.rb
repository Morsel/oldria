require 'spec/spec_helper'

describe UsersController do

  describe "GET index" do
    context "responding with js" do
      before(:each) do
        current_user = Factory(:user)
        controller.stubs(:current_user).returns(current_user)

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

  describe "GET show" do
    before(:each) do
      @user = Factory(:user, :id => 3)
      User.stubs(:find).returns(@user)
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

  describe "editing" do

    it "should render the edit page" do
      user = Factory(:user)
      controller.stubs(:current_user).returns(user)
      get :edit, :id => user.id
      response.should redirect_to(edit_user_profile_path(:user_id => user.id))
    end

  end

  describe "updating user attributes" do

    before(:each) do
      @user = Factory(:user)
      controller.stubs(:current_user).returns(@user)
      User.expects(:find).returns(@user)
    end

    it "should update the user" do
      @user.expects(:update_attributes).with("username" => "Hammy").returns(true)
      put :update, :id => @user.id, :user => { :username => "Hammy" }
    end

    it "should create a default employment" do
      @user.expects(:create_default_employment).with("restaurant_role_id" => 1).returns(true)
      put :update, :id => @user.id, :user => { :username => "Hammy", :default_employment => { :restaurant_role_id => 1 } }
    end

  end

end
