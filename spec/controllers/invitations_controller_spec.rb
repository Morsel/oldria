require 'spec/spec_helper'

describe InvitationsController do
  integrate_views
  before(:each) do
    @invitee = Factory(:user, :perishable_token =>"abc789", :username => "johnjohn", :confirmed_at => nil)
  end

  describe "GET show" do
    context "when no one is logged in" do
      context "user is found" do
        before do
          User.expects(:find_using_perishable_token).with("abc789").returns(@invitee)
          get :show, :id => "abc789"
        end

        it { assigns[:user].should eql(@invitee) }
        it { should redirect_to(complete_registration_path) }

        it "should flash a notice" do
          flash[:notice].should_not be_nil
        end

        it "should confirm the user" do
          @invitee.should be_confirmed
        end
      end
    
      context "and the user is not found by token" do
        before do
          User.stubs(:find_using_perishable_token) # returns nil
          get :show, :id => "abc789"
        end

        it { assigns[:user].should be_nil }
        it { should redirect_to(login_path) }

        it "should flash an error message" do
          flash[:error].should_not be_nil
        end
        
        context "and is the invitee who is confirmed" do
          before do
            @invitee.confirmed_at = Time.now; @invitee.save
          end
          
          it "should redirect to a special login page" do
            get :show, :id => 'expired_id', :user_id => @invitee.id
            response.should redirect_to(login_invitations_path(:user_session => {:username => @invitee.username}))
          end
        end

        context "and is the invitee who is not confirmed" do
          it "should redirect to a special login page" do
            get :show, :id => 'expired_id', :user_id => @invitee.id
            response.should redirect_to(resend_confirmation_users_path)
          end
        end
      end
    end

    context "when someone is already logged in" do
      before do
        activate_authlogic
        UserSession.create(Factory(:user))
        (UserSession.find).should_not be_nil
      end

      it "should log out the user first" do
        get :show, :id => "abc789"
        (UserSession.find).should be_nil
      end
    end
  end # GET show
end
