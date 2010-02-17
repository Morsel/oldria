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

describe Admin::Announcement do
  it "should set a class-based title of 'Announcement'" do
    Admin::Announcement.title.should == "Announcement"
  end

  it "should be considered a broadcast message" do
    Admin::Announcement.new.should be_broadcast
  end
end
