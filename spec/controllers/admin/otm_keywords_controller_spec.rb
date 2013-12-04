require_relative '../spec_helper'

describe Admin::OtmKeywordsController do

  before(:each) do
    @user = Factory.stub(:admin)
    controller.stubs(:current_user).returns(@user)
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  it "should create a new keyword" do
    keyword = Factory.build(:otm_keyword)
    OtmKeyword.expects(:new).returns(keyword)
    keyword.expects(:save).returns(true)
    post :create, :otm_keyword => { :name => "Foo", :category => "Bar" }
    response.should be_redirect
  end

  describe "GET 'edit'" do
    it "should be successful" do
      keyword = Factory(:otm_keyword)
      get 'edit', :id => keyword.id
      response.should be_success
    end
  end
end
