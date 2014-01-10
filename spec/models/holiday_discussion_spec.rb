require_relative '../spec_helper'

describe HolidayDiscussion do
  before(:each) do
    @valid_attributes = {
      :restaurant_id => 1,
      :holiday_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    HolidayDiscussion.create!(@valid_attributes)
  end

	describe "for all the scopes" do
	  it "with_replies" do
	  	holiday_discussion = HolidayDiscussion.create!(@valid_attributes)
	  	HolidayDiscussion.with_replies.should == HolidayDiscussion.find(:all, :conditions => ["holiday_discussions.comments_count > ?", "0"])
	  end

	  it "without_replies" do
	  	holiday_discussion = HolidayDiscussion.create!(@valid_attributes)
	  	HolidayDiscussion.without_replies.should == HolidayDiscussion.find(:all, :conditions => ["holiday_discussions.comments_count = ?", "0"])
	  end
	  
	  it "needs_reply" do
	  	holiday_discussion = HolidayDiscussion.create!(@valid_attributes)
	  	HolidayDiscussion.needs_reply.should == HolidayDiscussion.find(:all, :conditions => ["holiday_discussions.comments_count = ?", "0"])
	  end

	  it "open" do
	  	holiday_discussion = HolidayDiscussion.create!(@valid_attributes)
	  	HolidayDiscussion.open.should == HolidayDiscussion.find(:all, :conditions => ["holiday_discussions.accepted = ?", false])
	  end

	  it "closed" do
	  	holiday_discussion = HolidayDiscussion.create!(@valid_attributes)
	  	HolidayDiscussion.closed.should == HolidayDiscussion.find(:all, :conditions => ["holiday_discussions.accepted = ?", true])
	  end
	end 

	describe "#inbox_title" do
    it "should return the inbox_title" do
    	holiday_discussion = HolidayDiscussion.create!(@valid_attributes)
      holiday_discussion.inbox_title.should == holiday_discussion.holiday.try(:name)
    end 
  end

  describe "#email_title" do
    it "should return the email_title" do
    	holiday_discussion = HolidayDiscussion.create!(@valid_attributes)
      holiday_discussion.email_title.should == %Q[Discussion for "#{holiday_discussion.inbox_title}"]
    end 
  end

  describe "#read_by?" do
    it "should return the read_by" do
    	holiday_discussion = HolidayDiscussion.create!(@valid_attributes)
    	user = FactoryGirl.create(:user)
      holiday_discussion.read_by?(user).should == holiday_discussion.accepted? || holiday_discussion.readings.map(&:user).include?(user)
    end 
  end

  describe "#message" do
    it "should return the message" do
    	holiday_discussion = HolidayDiscussion.create!(@valid_attributes)
      holiday_discussion.message.should == holiday_discussion.holiday_reminders.first.message
    end 
  end

  describe "#scheduled_at" do
    it "should return the scheduled_at" do
    	holiday_discussion = HolidayDiscussion.create!(@valid_attributes)
      holiday_discussion.scheduled_at.should == holiday_discussion.created_at
    end 
  end

  describe "#employees" do
    it "should return the employees" do
    	holiday_discussion = HolidayDiscussion.create!(@valid_attributes)
      holiday_discussion.employees.should == holiday_discussion.restaurant.employees
    end 
  end
  
  describe "#recipients_can_reply?" do
    it "should return the recipients_can_reply?" do
    	holiday_discussion = HolidayDiscussion.create!(@valid_attributes)
      holiday_discussion.recipients_can_reply?.should ==  true
    end 
  end

end

