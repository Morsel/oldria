require_relative '../spec_helper'

describe Comment do

  it "should clear read status of discussions when a new comment is added" do
    user1 = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user)
    convo = FactoryGirl.create(:discussion, :users => [user1, user2])
    convo.read_by!(user2)
    convo.comments.create(:title => "A comment", :user_id => user1.id)
    convo.read_by?(user2).should be_false
  end
  
end
