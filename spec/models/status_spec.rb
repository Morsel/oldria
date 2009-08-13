require File.dirname(__FILE__) + '/../spec_helper'

describe Status do
  it "should be valid" do
    Status.new.should be_valid
  end
end

describe Status, "order" do
  it "should return lists of status in reverse-chrono order" do
    joe = Factory(:user, :username => 'joe')
    post1 = Factory(:status, :user => joe, :created_at => 3.minutes.ago)
    post2 = Factory(:status, :user => joe, :created_at => 2.minutes.ago)
    post3 = Factory(:status, :user => joe, :created_at => 1.minutes.ago)
    
    Status.all.should eql([post3, post2, post1])
  end
end

describe Status, "html stripping" do
  it "should strip html content (example 1)" do
    status = Factory.build(:status, :message => '<h1>This is a message</h1>')
    status.strip_html.should == 'This is a message'
    status.save
    status.message.should == 'This is a message'
  end
  
  it "should strip html content before save" do
    status = Factory.create(:status, :message => '<em>This</em> is a <a href="http://www.google.com">message</a>')
    status.message.should == 'This is a message'
  end
end