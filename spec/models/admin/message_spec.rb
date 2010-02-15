require 'spec/spec_helper'

describe Admin::Message do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:admin_message)
  end

  it "should create a new instance given valid attributes" do
    Admin::Message.create!(@valid_attributes)
  end
end
