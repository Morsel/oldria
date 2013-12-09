class Output
  def puts(message)
  end
end

output = Rails.env.test? ? Output.new : STDOUT

namespace :subscriptions do
  desc "queries braintree for past due accounts and marks them"
  task :mark_past_due => :environment do
    braintree_ids = BraintreeConnector.past_due_subscriptions
    past_due_subscriptions = Subscription.find(braintree_ids)
    past_due_subscriptions.each{|s| s.past_due!}
    output.puts "Found #{past_due_subscriptions.length} subscriptions that are past due."
  end

  desc "cancels past due accounts from braintree"
  task :purge_expired => :environment do
    past_due_subscriptions = Subscription.all(:conditions => "status = '#{Subscription::Status::PAST_DUE}' AND end_date < '#{Date.today.to_date}'")
    past_due_subscriptions.each do |subscription|
      destroy_result = BraintreeConnector.cancel_subscription(subscription)
      if destroy_result.success?
        subscription.subscriber.cancel_subscription!(:terminate_immediately => true)
      end
    end
  end

  desc "convert premium accounts"
  task :convert_premium => :environment do
    User.find_all_by_premium_account(true).each { |u| u.make_complimentary! }
    Restaurant.find_all_by_premium_account(true).each { |r| r.make_complimentary! }
  end
end