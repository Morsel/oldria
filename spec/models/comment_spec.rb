require_relative '../spec_helper'

describe Comment do

it { should have_many(:attachments).dependent(:destroy) }
it { should belong_to(:user) }
it { should accept_nested_attributes_for(:attachments) }


  it "should clear read status of discussions when a new comment is added" do
    user1 = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user)
    convo = FactoryGirl.create(:discussion, :users => [user1, user2])
    convo.read_by!(user2)
    convo.comments.create(:title => "A comment", :user_id => user1.id)
    convo.read_by?(user2).should be_false
  end

  describe "#clear_read_status" do
  	it "should return the clear readings" do
	    comment = FactoryGirl.create(:comment)
	    comment.clear_read_status.should == comment.commentable.readings.each { |r| r.destroy }
	  end   
  end

  describe "#restaurant" do
  	it "should return the restaurant" do
	    comment = FactoryGirl.create(:comment)
	     if comment.commentable.respond_to?(:restaurant)
	      restaurant = comment.commentable.restaurant
	    else
	      restaurant = comment.user.employments.present? && comment.user.primary_employment.restaurant
	    end
	      comment.restaurant.should == restaurant
	  end   
  end

  describe "#employment" do
  	it "should return the employment" do
	    comment = FactoryGirl.create(:comment)
	     if comment.restaurant
	      employment = comment.user.employments.find_by_restaurant_id(restaurant.id)
	    else
	      employment = comment.user.primary_employment
	    end
	      comment.employment.should == employment
	  end   
  end

  describe "#commentable_title" do
  	it "should return the commentable title" do
	    comment = FactoryGirl.create(:comment)
	     if comment.commentable.respond_to?(:admin_message)
	      title = commentable.admin_message.try(:message)
	    elsif comment.commentable.respond_to?(:discussionable)
	      title = comment.discussionable.try(:subject)
	    end
	      comment.commentable_title.should == title
	  end   
  end

  describe "#activity_name" do
  	it "should return the activity name" do
	    comment = FactoryGirl.create(:comment)
	    comment.activity_name.should == "comment on \"#{comment.commentable_title}\""
	  end   
  end

  describe "#track_activity?" do
  	it "should return the track activity" do
	    comment = FactoryGirl.create(:comment)
	    if comment.commentable.is_a?(Admin::Conversation) || comment.commentable.is_a?(AdminDiscussion) || comment.commentable.is_a?(SoloDiscussion)
	      track = true
	    else
	      track = false
	    end
	    comment.track_activity?.should == track
	  end   
  end
  
end
