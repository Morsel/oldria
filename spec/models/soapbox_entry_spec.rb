require_relative '../spec_helper'

describe SoapboxEntry do
  it { should belong_to(:featured_item) }

  describe "#title" do
    it "should return title" do
      soapbox_entry = FactoryGirl.create(:soapbox_entry)
      soapbox_entry.title.should == soapbox_entry.featured_item.title
    end
  end

  describe "#display_message" do
    it "should return display_message" do
      soapbox_entry = FactoryGirl.create(:soapbox_entry)
      soapbox_entry.display_message.should == soapbox_entry.featured_item.display_message
    end
  end

  describe "#comments" do
    it "should return comments" do
      soapbox_entry = FactoryGirl.create(:soapbox_entry)
      soapbox_entry.comments.should == soapbox_entry.featured_item.comments(false)
    end
  end

  describe "#published?" do
    it "should return published?" do
      soapbox_entry = FactoryGirl.create(:soapbox_entry)
      if soapbox_entry.published == true && soapbox_entry.published_at <= Time.zone.now
      	value = true
      else 
        value = false	
      end 	
      soapbox_entry.published?.should == value
    end
  end  

  describe "#upcoming?" do
    it "should return upcoming?" do
      soapbox_entry = FactoryGirl.create(:soapbox_entry)
	      if soapbox_entry.published == true && soapbox_entry.published_at > Time.zone.now
	      	value = true
	      else 
	      	value = false	
	      end 	
	      soapbox_entry.upcoming?.should == value
	  end
  end

  describe "#latest_answer" do
    it "should return latest_answer" do
      soapbox_entry = FactoryGirl.create(:soapbox_entry)
      soapbox_entry.latest_answer.should == soapbox_entry.featured_item.last_comment
    end
  end


end

