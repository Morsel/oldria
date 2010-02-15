require 'spec/spec_helper'

describe Admin::Conversation do
  should_belong_to :admin_message
  should_belong_to :recipient, :class_name => 'Employment'

  before(:each) do
    @valid_attributes = {
      :recipient_id => 1,
      :admin_message_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Admin::Conversation.create!(@valid_attributes)
  end
end
