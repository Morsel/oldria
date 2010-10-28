module HasSubscription

  def has_subscription
    has_one :subscription, :as => :subscriber
    has_many :paid_subscriptions, :class_name => "Subscription", :as => :payer
    include InstanceMethods
  end

  module InstanceMethods

    def account_type
      return "Complimentary Premium" if complimentary_account?
      return "Premium" if premium_account?
      "Basic"
    end

    def subscriber_type
      if self.is_a?(User) then "User" else "Restaurant" end
    end

    def can_be_staff?
      subscriber_type == "User"
    end
    
    def can_be_payer?
      subscriber_type == "Restaurant"
    end
    
    def premium_account
      premium_account?
    end

    def premium_account?
      subscription && subscription.premium? && subscription.active?
    end

    def complimentary_account?
      subscription && subscription.complimentary?
    end

    def account_in_overtime?
      subscription && subscription.in_overtime?
    end

    def make_premium!(bt_subscription)
      self.subscription = Subscription.create(
          :kind => "#{subscriber_type} Premium",
          :payer => self,
          :start_date => Date.today,
          :braintree_id => bt_subscription.subscription.id)
      save
      self.subscription
    end
    
    def make_staff_account!(payer)
      return unless can_be_staff?
      return unless payer.can_be_payer?
      self.subscription = Subscription.create(
          :kind => "User Premium",
          :payer => payer, 
          :start_date => Date.today,
          :braintree_id => nil)
      save
      self.subscription
    end

    def make_complimentary!
      subscription.destroy if subscription.present?
      self.subscription = Subscription.create(
          :kind => "#{subscriber_type} Premium",
          :payer => nil,
          :start_date => Date.today,
          :braintree_id => nil)
      save
      self.subscription
    end

    def cancel_subscription!(options)
      raise "Specify a cancel subscription method" if options[:terminate_immediately].nil?
      if options[:terminate_immediately]
        subscription.destroy if subscription.present?
        self.subscription = nil
      else
        if subscription.complimentary?
          subscription.update_attributes(:end_date => 1.month.from_now.to_date)
        else
          subscription.set_end_date_from_braintree
        end
      end
    end

  end

end

ActiveRecord::Base.extend(HasSubscription)