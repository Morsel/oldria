require_relative '../spec_helper'

describe MediaNewsletterSubscription do
  it { should belong_to :restaurant }
	it { should belong_to :media_newsletter_subscriber }

   before do
    @restaurant = FactoryGirl.create(:restaurant, :name => "Megan's Place")
   end

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:media_newsletter_subscription)
  end

  it "should create a new instance given valid attributes" do
    MediaNewsletterSubscription.create!(@valid_attributes)
  end
end 
