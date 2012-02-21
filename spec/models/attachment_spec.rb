require 'spec/spec_helper'

describe Attachment do
  before(:each) do
    @valid_attributes = {
      :attachment_file_name => "value for attachment_file_name"
    }
  end

  it "should create a new instance given valid attributes" do
    Attachment.create!(@valid_attributes)
  end
end

