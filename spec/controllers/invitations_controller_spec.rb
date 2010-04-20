require 'spec/spec_helper'

describe InvitationsController do
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
        it { should render_template(:show) }

        it "should flash a notice" do
          flash[:notice].should_not be_nil
        end

        it "should confirm the user" do
          @invitee.should be_confirmed
        end
      end
    
      context "user is not found" do
        before do
          User.expects(:find_using_perishable_token).with("abc789")
          get :show, :id => "abc789"
        end

        it { assigns[:user].should be_nil }
        it { should redirect_to(root_url) }

        it "should flash an error message" do
          flash[:error].should_not be_nil
        end
      end
    end

    context "when a user is already logged in" do
      context "and is the invitee" do
        it "should redirect to the dashboard" do
          get :show, :id => 'expired_id', :user_id => @invitee.id
          response.should redirect_to(root_path)
        end
      end
    end

  end # GET show
end

=begin

If I click through an invitation email link, and another user is logged in, that user should be logged out.  *I* should be logged in instead, then view the "short registration" page.  

If I try to save the short confirmation page without specifying a password, I should see the standard rails error. 

If I click thru the invitation email link, and no other user is logged in, I should be logged in automatically. 

If I click thru the invitation email link 2x, after doing the required actions, I should be logged in automatically. 

=end
