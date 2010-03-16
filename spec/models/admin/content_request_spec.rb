# == Schema Information
# Schema version: 20100316193326
#
# Table name: admin_messages
#
#  id           :integer         not null, primary key
#  type         :string(255)
#  scheduled_at :datetime
#  status       :string(255)
#  message      :text
#  created_at   :datetime
#  updated_at   :datetime
#  holiday_id   :integer
#

require 'spec/spec_helper'

describe Admin::ContentRequest do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:admin_message, :type => 'Admin::ContentRequest')
  end

  it "should create a new instance given valid attributes" do
    Admin::ContentRequest.create!(@valid_attributes)
  end
end
