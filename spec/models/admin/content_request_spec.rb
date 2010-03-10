require 'spec/spec_helper'

describe Admin::ContentRequest do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:admin_message, :type => 'Admin::ContentRequest')
  end

  it "should create a new instance given valid attributes" do
    Admin::ContentRequest.create!(@valid_attributes)
  end
end
