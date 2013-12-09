require_relative '../spec_helper'
require 'rake'
require 'delorean'

describe "Subscription Rake Tasks" do
  before(:each) do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake::Task.define_task(:environment)
    # Rake.application.rake_require "lib/tasks/subscription"
    load "#{Rails.root}/lib/tasks/subscription.rake"
  end

  describe "#mark_past_due" do
    let(:subscription) { FactoryGirl.create(:subscription) }
    it "should invoke past_due! on all subscriptions that are past due" do
      subscription.expects(:past_due!)
      subscription_ids = [subscription.id]
      BraintreeConnector.expects(:past_due_subscriptions).returns(subscription_ids)
      Subscription.expects(:find).with(subscription_ids).returns([subscription])
      @rake["subscriptions:mark_past_due"].invoke
    end
  end

  describe "#purge_expired" do
    let(:subscriber) { FactoryGirl.create(:user) }
    it "should invoke past_due! on all subscriptions that are past due" do
      Delorean.time_travel_to("1 month ago") do
        subscriber.subscription = @expired = FactoryGirl.create(:subscription, :braintree_id => "expired", :status => Subscription::Status::PAST_DUE, :subscriber_id => subscriber.id, :subscriber_type => subscriber.class.name)
        subscriber.save
        @grace_period = FactoryGirl.create(:subscription, :braintree_id => "grace", :status => Subscription::Status::PAST_DUE)
        @active = FactoryGirl.create(:subscription, :braintree_id => "active", :end_date => nil)
      end
      @expired.update_attribute(:end_date, 1.day.ago.to_date)
      @grace_period.update_attribute(:end_date, 1.day.from_now.to_date)

      BraintreeConnector.expects(:cancel_subscription).with(@expired).returns(stub(:success? => true))

      @rake["subscriptions:purge_expired"].invoke

      Subscription.all.should == [@grace_period, @active]
    end
  end
end