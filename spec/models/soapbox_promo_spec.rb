require_relative '../spec_helper'

describe SoapboxPromo do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :body => "value for body"
    }
  end

  it "should create a new instance given valid attributes" do
    SoapboxPromo.create!(@valid_attributes)
  end
end


