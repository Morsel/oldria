require_relative '../spec_helper'

describe Following do
  before(:each) do
    @friend = Factory(:user, :username => "friend")
    @follower = Factory(:user,:username => "follower")
  end
  
  it "should be valid with a follower and a friend" do
    Following.new(:friend => @friend, :follower => @follower).should be_valid
  end
  
  it "should not be valid when trying to follow yourself" do
    following = Following.new(:friend => @friend, :follower => @friend)
    following.should_not be_valid
    following.errors.on(:base).should eql("You can't follow yourself")
  end
  
  it "should not create duplicates" do
    Following.create(:friend => @friend, :follower => @follower).should be_true
    following = Following.new(:friend => @friend, :follower => @follower)
    following.should_not be_valid
    following.errors.on(:friend_id).should eql("You already follow that person")
  end
end
