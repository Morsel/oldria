require 'spec/spec_helper'

describe Admin::PrTip do
  it "should be valid" do
    Admin::PrTip.new.should be_valid
  end
end
