require_relative '../spec_helper'
# encoding: utf-8  
describe Attachment do
  before(:each) do
    @valid_attributes = {
      :attachment_file_name => "attachment_file_name.pdf"
    }
  end

  it "should create a new instance given valid attributes" do
    Attachment.create!(@valid_attributes)
  end

  it "should fail to create an attachment with special characters in the name" do
    a = Attachment.new(:attachment_file_name => "+#Huber+@+King_Crab&_with_Ossetra_Caviar_and_Fennel+closer.jpg")
    a.should_not be_valid
  end
end

