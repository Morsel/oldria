require 'spec_helper'

describe Promotion do
  before(:each) do
    @valid_attributes = {
      :promotion_type_id => 1,
      :details => "value for details",
      :link => "value for link",
      :start_date => Date.today,
      :end_date => Date.today,
      :date_description => "value for date_description"
    }
  end

  it "should create a new instance given valid attributes" do
    Promotion.create!(@valid_attributes)
  end
end
