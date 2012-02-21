require 'spec_helper'

describe Promotion do
  before(:each) do
    promo_type = Factory(:promotion_type)
    @valid_attributes = {
      :promotion_type_id => promo_type.id,
      :details => "value for details",
      :link => "value for link",
      :start_date => Date.today,
      :end_date => Date.today,
      :date_description => "value for date_description",
      :restaurant_id => 1,
      :headline => "My great headline"
    }
  end

  it "should create a new instance given valid attributes" do
    Promotion.create!(@valid_attributes)
  end
end

