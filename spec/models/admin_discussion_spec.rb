require_relative '../spec_helper'

describe AdminDiscussion do
  it { should belong_to :restaurant }
  it { should belong_to :discussionable } 
  it { should validate_uniqueness_of(:restaurant_id).scoped_to(:discussionable_id) }
  it { should validate_uniqueness_of(:restaurant_id).scoped_to(:discussionable_type) }

  describe "#message" do
  	it "should return the message" do
	    admin_discussion = FactoryGirl.create(:admin_discussion)
	    admin_discussion.message.should == [admin_discussion.discussionable.subject, admin_discussion.discussionable.body].reject(&:blank?).join(": ")
	  end   
  end

  describe "#display_message" do
  	it "should return the display message" do
	    admin_discussion = FactoryGirl.create(:admin_discussion)
	    admin_discussion.display_message.should == admin_discussion.discussionable.display_message
	  end   
  end

  describe "#inbox_title" do
  	it "should return the inbox title" do
	    admin_discussion = FactoryGirl.create(:admin_discussion)
	    admin_discussion.inbox_title.should == admin_discussion.discussionable.class.title
	  end   
  end

  describe "#email_title" do
  	it "should return the email title" do
	    admin_discussion = FactoryGirl.create(:admin_discussion)
	    admin_discussion.email_title.should == admin_discussion.inbox_title
	  end   
  end

  describe "#email_body" do
  	it "should return the email body" do
	    admin_discussion = FactoryGirl.create(:admin_discussion)
	    admin_discussion.email_body.should == admin_discussion.email_body
	  end   
  end

  describe "#short_title" do
  	it "should return the short title" do
	    admin_discussion = FactoryGirl.create(:admin_discussion)
	    admin_discussion.short_title.should == "rd"
	  end   
  end

  describe "#scheduled_at" do
  	it "should return the scheduled at" do
	    admin_discussion = FactoryGirl.create(:admin_discussion)
	    admin_discussion.scheduled_at.should == admin_discussion.discussionable.scheduled_at
	  end   
  end
  
  describe "#soapbox_entry" do
  	it "should return the soapbox entry" do
	    admin_discussion = FactoryGirl.create(:admin_discussion)
	    admin_discussion.soapbox_entry.should == admin_discussion.discussionable.soapbox_entry
	  end   
  end

  describe "#employments" do
  	it "should return the employments" do
	    admin_discussion = FactoryGirl.create(:admin_discussion)
	    admin_discussion.employments.should == admin_discussion.restaurant.employments.find(:all, include: :employee) & admin_discussion.discussionable.employment_search.try(:employments).try(:all, :include => :employee)
	  end   
  end

  describe "#employees" do
  	it "should return the employees" do
	    admin_discussion = FactoryGirl.create(:admin_discussion)
	    admin_discussion.employees.should == @employees ||= admin_discussion.employments.map(&:employee)
	  end   
  end

  describe "#recipients_can_reply?" do
  	it "should return the recipients can reply?" do
	    admin_discussion = FactoryGirl.create(:admin_discussion)
	    admin_discussion.recipients_can_reply?.should == true
	  end   
  end



end
