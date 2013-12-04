require_relative '../spec_helper'

describe Promo do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :body => "value for body"
    }
  end

  it "should create a new instance given valid attributes" do
    Promo.create!(@valid_attributes)
  end
end

