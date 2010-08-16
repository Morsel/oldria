require 'spec_helper'

describe QuestionRole do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
    }
  end

  it "should create a new instance given valid attributes" do
    QuestionRole.create!(@valid_attributes)
  end
  
  it "should have many restaurant roles" do
    QuestionRole.new.restaurant_roles.should be_a_kind_of(Array)
  end
end
