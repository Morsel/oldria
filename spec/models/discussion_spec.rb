require 'spec/spec_helper'

describe Discussion do
  should_have_many :discussion_seats
  should_have_many :users, :through => :discussion_seats
  should_belong_to :poster, :class_name => 'User'

  before(:each) do
    @valid_attributes = Factory.attributes_for(:discussion)
  end

  it "should create a new instance given valid attributes" do
    Discussion.create!(@valid_attributes)
  end
end
