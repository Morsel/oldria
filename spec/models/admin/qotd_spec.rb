# == Schema Information
#
# Table name: admin_messages
#
#  id         :integer         not null, primary key
#  type       :string(255)
#  sent_at    :datetime
#  status     :string(255)
#  message    :text
#  created_at :datetime
#  updated_at :datetime
#

require 'spec/spec_helper'

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
