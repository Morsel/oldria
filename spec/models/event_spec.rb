# == Schema Information
# Schema version: 20100708221553
#
# Table name: events
#
#  id            :integer         not null, primary key
#  restaurant_id :integer
#  title         :string(255)
#  start_at      :datetime
#  end_at        :datetime
#  location      :string(255)
#  description   :text
#  category      :string(255)
#  status        :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  parent_id     :integer
#

require 'spec_helper'

describe Event do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:event)
  end

  it "should create a new instance given valid attributes" do
    Event.create!(@valid_attributes)
  end
  
  it "should be required to have a status if it's a private event" do
    params = Factory.attributes_for(:event, :category => "Private")
    event = Event.create(params)
    event.should have(1).error_on(:status)
  end
  
  it "should be required to have a location" do
    params = Factory.attributes_for(:event, :category => "Holiday", :location => nil)
    event = Event.create(params)
    event.should have(1).error_on(:location)
  end
  
  it "shouldn't be required to have a location if it's an admin event" do
    params = Factory.attributes_for(:event, :category => "admin_holiday", :location => nil)
    event = Event.create(params)
    event.should have(0).errors_on(:location)
  end
end
