require 'spec_helper'

describe Admin::ProfileQuestionsController do

  before(:each) do
    @user = Factory(:admin)
    controller.stubs(:current_user).returns(@user)    
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
      assigns[:question].should_not be_nil
    end
  end
end
