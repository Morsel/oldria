# == Schema Information
#
# Table name: subscriptions
#
#  id               :integer         not null, primary key
#  braintree_id     :string(255)
#  start_date       :date
#  subscriber_id    :integer
#  subscriber_class :string(255)
#  payer_id         :integer
#  payer_class      :string(255)
#  kind             :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe Subscription do
  before(:each) do
    @valid_attributes = {
      :braintree_id => "value for braintree_id",
      :start_date => Date.today
    }
  end

  it "should create a new instance given valid attributes" do
    Subscription.create!(@valid_attributes)
  end
end
