require 'spec/spec_helper'

describe AccountType do
  it "should be valid" do
    AccountType.new.should be_valid
  end
end
