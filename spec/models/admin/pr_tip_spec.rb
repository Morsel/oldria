# == Schema Information
# Schema version: 20100301222416
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
#

require 'spec/spec_helper'

describe Admin::PrTip do
  it "should set a class-based title of 'PR Tip'" do
    Admin::PrTip.title.should == "PR Tip"
  end
end
