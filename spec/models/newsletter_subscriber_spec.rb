require_relative '../spec_helper'

describe NewsletterSubscriber do
  it { should have_many(:newsletter_subscriptions).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:email) }
  it do
    should validate_uniqueness_of(:email).
      with_message('has already registered')
  end

  it do
    should_not allow_value('/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i').
      for(:email).
       with_message('is not a valid email address')
  end

  it do
    should validate_confirmation_of(:password)
  end
  it { should validate_presence_of(:password) }

  before(:each) do
    @valid_attributes = {
      :email => "myemail@compy.com",
      :password => "secret",
      :password_confirmation => "secret"
    }
  end

  it "should create a new instance given valid attributes" do
    NewsletterSubscriber.create!(@valid_attributes)
  end

  describe "#confirm!" do
    it "should return confirm!" do
      newsletter_subscriber = NewsletterSubscriber.create!(@valid_attributes)
      newsletter_subscriber.confirm!.should == newsletter_subscriber.update_attribute(:confirmed_at, Time.now)
    end   
  end

  describe "#confirmation_token" do
    it "should return confirmation token" do
      newsletter_subscriber = NewsletterSubscriber.create!(@valid_attributes)
      newsletter_subscriber.confirmation_token.should == Digest::MD5.hexdigest(newsletter_subscriber.id.to_s + newsletter_subscriber.created_at.to_s)
    end   
  end

  describe ".build_from_registration" do
    it "should return confirmation token" do
      random_password = Array.new(10).map { (65 + rand(58)).chr }.join
      newsletter_subscriber = FactoryGirl.build(:newsletter_subscriber,:first_name => 'sender',:last_name=>'test',:email=>"rewr.23@gmail.com",:password=>random_password,:password_confirmation=>random_password)
    end   
  end

  describe ".create_from_user" do
    it "should return create from user" do
      user = FactoryGirl.build(:user)
      newsletter_subscriber = FactoryGirl.build(:newsletter_subscriber,:first_name => user.first_name,:last_name=>user.last_name,:email=>user.email,:user_id=>user.id,:confirmed_at=>Time.now)
    end   
  end

  describe ".has_subscription" do
    it "should return create from user" do
      random_password = Array.new(10).map { (65 + rand(58)).chr }.join
      restaurant = FactoryGirl.build(:restaurant)
      newsletter_subscriber = FactoryGirl.build(:newsletter_subscriber,:first_name => 'sender',:last_name=>'test',:email=>"rewr.23@gmail.com",:password=>random_password,:password_confirmation=>random_password)
      newsletter_subscriber.has_subscription(restaurant).should == NewsletterSubscription.exists?(:newsletter_subscriber_id => newsletter_subscriber.id, :restaurant_id => restaurant.id)
    end   
  end

  # it "should send a confirmation email after creation" do
  #   #UserMailer.expects(:send_later).with(:newsletter_subscription_confirmation, kind_of(NewsletterSubscriber))
  #   # NewsletterSubscriber.create(@valid_attributes)
  #   UserMailer.expects(:newsletter_subscription_confirmation).with(NewsletterSubscriber.create(@valid_attributes))
  # end

end

