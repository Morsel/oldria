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