require_relative '../spec_helper'

describe InvitationsController do
  integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end  


  describe "accessing the new invite form" do
    
    it "should log out the current user" do
      activate_authlogic
      UserSession.create(FactoryGirl.create(:user))
      UserSession.any_instance.expects(:destroy)
      get :new
      response.should render_template('invitations/new')
    end
  end
  
  describe "creating a new invite" do
    
    it "should create an invite from a valid form submit" do
      invite = FactoryGirl.build(:invitation)
      Invitation.expects(:new).with("email" => "foo@bar.com").returns(invite)
      invite.expects(:save).returns(true)
      post :create, :invitation => { :email => "foo@bar.com" }
      response.should be_redirect
    end
    
  end

  describe "GET show" do
    
    before(:each) do
      @invitee = FactoryGirl.create(:user, :perishable_token =>"abc789", :username => "johnjohn", :confirmed_at => nil)
    end

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
          
          it "should redirect to the login page with their username" do
            get :show, :id => 'expired_id', :user_id => @invitee.id
            #response.should redirect_to(login_path(:user_session => {:username => @invitee.username}))
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
      before(:each) do
        activate_authlogic
        UserSession.create(FactoryGirl.create(:user))
        UserSession.find.should_not be_nil
      end

      it "should log out the user first" do
        UserSession.any_instance.expects(:destroy)
        get :show, :id => "abc789"
      end
    end
  end # GET show

  it "confirm action should render confirm template" do
    invite = FactoryGirl.create(:invitation)
    get :confirm,:id=>invite.id
    response.should render_template(:confirm)
  end

  it "work for submit_recommendation" do
    get :submit_recommendation
    response.should redirect_to :action => :recommend
  end

end
