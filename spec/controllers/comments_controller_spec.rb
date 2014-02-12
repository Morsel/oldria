require_relative '../spec_helper'

describe CommentsController do
  integrate_views

  before(:all) do
    AdminDiscussion.destroy_all
    Comment.destroy_all
  end

  before(:each) do
    @parent = FactoryGirl.create(:admin_discussion)
    AdminDiscussion.stubs(:find).returns(@parent)
    @user = FactoryGirl.create(:user)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
  end

  describe "POST create" do
    it "should redirect to front burner when commenting on a FB post" do
      Comment.any_instance.stubs(:valid?).returns(true)
      post :create, :admin_discussion_id => @parent.id, :comment => {}
      response.should be_redirect
      response.redirect_url.should match(front_burner_path)
    end
    
    it "should mark the parent as read" do
      @parent.expects(:read_by!).with(@user)
      post :create, :admin_discussion_id => @parent.id, :comment => { :comment => "yay!" }
    end
  end
  
  describe "destroy" do
    
    it "should delete the comment" do
      comment = FactoryGirl.create(:comment)
      Comment.expects(:find).returns(comment)
      comment.expects(:destroy).returns(true)
      delete :destroy, :id => comment.id
    end
  end

end
