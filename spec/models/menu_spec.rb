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
