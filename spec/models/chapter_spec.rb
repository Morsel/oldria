require 'spec_helper'

describe Chapter do
  before(:each) do
    @valid_attributes = {
      :topic_id => 1,
      :title => "value for title"
    }
  end

  it "should create a new instance given valid attributes" do
    Chapter.create!(@valid_attributes)
  end
end
