require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MediaRequestConversation do
  before(:each) do
    @valid_attributes = {
      :media_request_id => 1,
      :recipient_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    MediaRequestConversation.create!(@valid_attributes)
  end
end
