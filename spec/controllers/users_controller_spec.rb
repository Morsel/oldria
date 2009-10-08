require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
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
    
    context "as a media user" do
      before(:each) do
        @current_user = Factory(:user)
        @current_user.has_role! :media
        controller.stubs(:current_user).returns @current_user
      end

      it "should redirect to the homepage" do
        get :show, :id => 3
        response.should redirect_to(root_url)
      end
    end
  end
end
