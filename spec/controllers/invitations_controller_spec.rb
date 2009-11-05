require File.dirname(__FILE__) + '/../spec_helper'

describe InvitationsController do

  describe "GET 'show'" do
    before(:each) do
      @user = Factory(:user, :perishable_token =>"abc789", :username => "johnjohn", :confirmed_at => nil)
    end
    
    context "user is found" do
      before do
        User.expects(:find_using_perishable_token).with("abc789").returns(@user)
        get :show, :id => "abc789"
      end

      it { assigns[:user].should eql(@user) }
      it { should redirect_to(edit_user_path(@user)) }

      it "should flash a notice" do
        flash[:notice].should_not be_nil
      end

      it "should confirm the user" do
        @user.should be_confirmed
      end
    end
    
    context "user is not found" do
      before do
        User.expects(:find_using_perishable_token).with("abc789")
        get :show, :id => "abc789"
      end

      it { assigns[:user].should be_nil }
      it { should redirect_to(root_url) }

      it "should flash and error message" do
        flash[:error].should_not be_nil
      end
    end
  end
end
