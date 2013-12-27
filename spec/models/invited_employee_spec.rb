require_relative '../spec_helper'

describe InvitedEmployee do
  it { should validate_presence_of(:email) }
  it { should_not allow_value('/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i').for(:email).with_message("is not a valid email address"), :allow_blank => true }

  it do
    should validate_uniqueness_of(:email).
      with_message('That email address has already been invited')
  end
  
  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:invited_employee)
  end

  it "should create a new instance given valid attributes" do
    InvitedEmployee.create!(@valid_attributes)
  end
 
end	

