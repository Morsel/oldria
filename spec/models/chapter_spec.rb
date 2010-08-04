# == Schema Information
# Schema version: 20100802191740
#
# Table name: chapters
#
#  id         :integer         not null, primary key
#  topic_id   :integer
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  position   :integer         default(0)
#

require 'spec_helper'

describe Chapter do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:chapter, :topic => Factory(:topic))
  end

  it "should create a new instance given valid attributes" do
    Chapter.create!(@valid_attributes)
  end
end
