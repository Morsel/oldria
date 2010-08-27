require 'spec_helper'

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
      question = Factory(:profile_question)
      get :edit, :id => question.id
      response.should be_success
      assigns[:question].should == question
    end

    it "should update the question's data" do
      chapter = Factory(:chapter)
      Chapter.stubs(:find).returns(chapter)
      question = Factory(:profile_question)
      ProfileQuestion.expects(:find).returns(question)
      question.expects(:update_attributes).with("title" => "New title", "chapter_id" => "1").returns(true)
      put :update, :id => question.id, :profile_question => { :title => "New title", :chapter_id => "1" }
      response.should be_redirect
    end

  end

  describe "destruction!" do

    it "should destroy the question" do
      question = Factory(:profile_question)
      delete :destroy, :id => question.id
      ProfileQuestion.count.should == 0
    end

  end
  
  describe "roles" do
    
    it "should update a role's category" do
      role = Factory(:restaurant_role)
      RestaurantRole.stubs(:find).returns(role)
      role.expects(:update_attributes).with("category" => "New category")
      put :update_role, :role_id => role.id, :restaurant_role => { :category => "New category" }
    end
    
  end
end
