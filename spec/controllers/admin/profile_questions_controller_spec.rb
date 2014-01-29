require_relative '../../spec_helper'

describe Admin::ProfileQuestionsController do

  before(:each) do
    fake_admin_user
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
      assigns[:question].should_not be_nil
    end
  end

  describe "editing and updating" do

    it "should provide a page to edit the question" do
      question = FactoryGirl.create(:profile_question)
      get :edit, :id => question.id
      response.should be_success
      assigns[:question].should == question
    end

    it "should update the question's data" do
      chapter = FactoryGirl.create(:chapter)
      Chapter.stubs(:find).returns(chapter)
      question = FactoryGirl.create(:profile_question)
      ProfileQuestion.expects(:find).returns(question)
      question.expects(:update_attributes).with("title" => "New title", "chapter_id" => "1").returns(true)
      put :update, :id => question.id, :profile_question => { :title => "New title", :chapter_id => "1" }
      response.should be_redirect
    end

  end


  describe "sending notifications" do

    it "should send a notification to all users who are eligible to reply but have not done so yet" do
      question = FactoryGirl.create(:profile_question)
      ProfileQuestion.expects(:find).returns(question)
      question.expects(:notify_users!).returns(true)

      post :send_notifications, :id => question.id
    end
  end

  describe "GET index" do
    it "get the index page" do
      get :index
      response.should render_template(:index)
    end
  end

  describe "GET sort" do
    it "sort" do
      get :sort
      response.body.should be_blank 
    end
  end


end
