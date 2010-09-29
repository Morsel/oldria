require 'spec_helper'

describe Menu do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :change_frequency => "value for change_frequency",
      :remote_attachment_id => 1,
      :restaurant_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Menu.create!(@valid_attributes)
  end
end

# == Schema Information
#
# Table name: menus
#
#  id                   :integer         not null, primary key
#  name                 :string(255)
#  change_frequency     :string(255)
#  remote_attachment_id :integer
#  restaurant_id        :integer
#  created_at           :datetime
#  updated_at           :datetime
#

