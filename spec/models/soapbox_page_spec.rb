require_relative '../spec_helper'

describe SoapboxPage do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :slug => "value-for-slug",
      :content => "value for content"
    }
  end

  it "should create a new instance given valid attributes" do
    SoapboxPage.create!(@valid_attributes)
  end
end
