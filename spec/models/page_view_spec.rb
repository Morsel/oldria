require_relative '../spec_helper'

describe PageView do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :title => "value for title",
      :url => "value for url"
    }
  end

  it "should create a new instance given valid attributes" do
    PageView.create!(@valid_attributes)
  end
end
