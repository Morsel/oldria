require_relative '../spec_helper'

describe Admin::EmailStopwordsController do

  before(:each) do
    @user = Factory(:admin)
    controller.stubs(:current_user).returns(@user)    
  end

  it "should create new stopwords" do
    post :create, :admin_email_stopword => { :phrase => "some text to remove \n some more text to remove\nmoooo" }
    response.should be_redirect
    Admin::EmailStopword.count.should == 3
    Admin::EmailStopword.first.phrase.should == "some text to remove"
  end

end
