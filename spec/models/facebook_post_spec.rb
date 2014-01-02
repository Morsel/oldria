require_relative '../spec_helper'

describe FacebookPost do
it { should belong_to :source }

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:facebook_post)
  end

  it "should create a new instance given valid attributes" do
    FacebookPost.create!(@valid_attributes)
  end
 

end	

