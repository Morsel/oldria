require 'spec/spec_helper'

describe CommentsController do
  integrate_views

  before(:all) do
    AdminDiscussion.destroy_all
    Comment.destroy_all
  end

  before(:each) do
    @parent = Factory(:admin_discussion)
    AdminDiscussion.stubs(:find).returns(@parent)
    @user = Factory.stub(:user, :id => 1)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
  end

  describe "POST create" do
    it "should redirect to parent" do
      Comment.any_instance.stubs(:valid?).returns(true)
      post :create, :admin_discussion_id => @parent.id, :comment => {}
      response.should redirect_to( admin_discussion_path(assigns[:parent]) )
    end
    
    it "should mark the parent as read" do
      @parent.expects(:read_by!).with(@user)
      post :create, :admin_discussion_id => @parent.id, :comment => { :comment => "yay!" }
    end
  end
  
  describe "destroy" do
    
    it "should delete the comment" do
      comment = Factory(:comment)
      Comment.expects(:find).returns(comment)
      comment.expects(:destroy).returns(true)
      delete :destroy, :id => comment.id
    end
  end
end
