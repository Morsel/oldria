require 'spec/spec_helper'

describe Admin::Announcement do
  it "should set a class-based title of 'Announcement'" do
    Admin::Announcement.title.should == "Announcement"
  end

  it "should be considered a broadcast message" do
    Admin::Announcement.new.should be_broadcast
  end
end
