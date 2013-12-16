require_relative '../spec_helper'

describe FollowingsController do
  
  before(:each) do
    @user = FactoryGirl.create(:user)
    controller.stubs(:current_user).returns(@user)
  end

  it "should allow a user to follow someone" do
    friend = FactoryGirl.create(:user)
    post :create, :friend_id => friend.id
    response.should redirect_to(profile_path(friend.username))
    @user.followings.count.should == 1
  end

  it "should allow a user to unfollow someone" do
    friend = FactoryGirl.create(:user)
    @user.followings.create(:friend_id => friend.id)
    
    delete :destroy, :id => @user.followings.first.id
    response.should redirect_to(profile_path(friend.username))
    @user.followings.count.should == 0
  end
  
end
