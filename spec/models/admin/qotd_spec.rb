require_relative '../../spec_helper'

describe Admin::Qotd do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:admin_message, :type => 'Admin::Qotd')
  end

  it "should set a class-based title of 'Question of the Day'" do
    Admin::Qotd.title.should == "Question of the Day"
  end

  it "should set a class-based short title of 'QOTD'" do
    Admin::Qotd.shorttitle.should == "QOTD"
  end

  it "should create a new instance given valid attributes" do
    Admin::Qotd.create!(@valid_attributes)
  end
end


