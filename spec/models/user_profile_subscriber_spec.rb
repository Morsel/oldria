require_relative '../spec_helper'

describe UserProfileSubscriber do
	it { should belong_to :user_profile_subscriber }

	before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:user_profile_subscriber)
  end

end
