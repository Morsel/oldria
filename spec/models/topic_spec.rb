# == Schema Information
# Schema version: 20100802191740
#
# Table name: topics
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Topic do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
    }
  end

  it "should create a new instance given valid attributes" do
    Topic.create!(@valid_attributes)
  end
end
