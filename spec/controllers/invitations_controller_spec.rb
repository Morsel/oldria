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
    
      context "user is not found by token" do
        before do
          User.stubs(:find_using_perishable_token) # returns nil
          get :show, :id => "abc789"
        end

        it { assigns[:user].should be_nil }
        it { should redirect_to(login_path) }

        it "should flash an error message" do
          flash[:error].should_not be_nil
        end
        
        context "and is the invitee" do
          it "should redirect to the dashboard" do
            get :show, :id => 'expired_id', :user_id => @invitee.id
            response.should render_template(:login)
          end
        end
      end
    end
  end # GET show
end
