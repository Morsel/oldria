require_relative '../spec_helper'

describe UserSessionsController do

  it "should create a new session with valid login and password given" do
    user = Factory(:user)
    params = { :username => user.username, :password => "secret" }
    post :create, :user_session => params
    response.should be_redirect
  end
  
  it "should display an error when an invalid password is given" do
    user = Factory(:user)
    params = { :username => user.username, :password => "foo" }
    post :create, :user_session => params
    assigns[:user_session].errors.count.should == 1
    response.should render_template("user_sessions/new")
  end
  
  it "should display an error when the user's account has not been confirmed" do
    user = Factory(:user, :confirmed_at => nil)
    params = { :username => user.username, :password => "secret" }
    post :create, :user_session => params
    assigns[:user_session].errors.count.should == 1
    response.should render_template("user_sessions/new")
  end

end