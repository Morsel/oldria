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
    
    def public_account_type
      return "Premium" if premium_account?
      "Basic"
    end
    
    def staff_subscriptions
      paid_subscriptions.user_subscriptions
    end
    
    def account_payer_type
      return "Personal" unless subscription
      if subscription.staff_account? then "Staff" else "Personal" end
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
    
    def can_be_staff?
      subscriber_type == "User"
    end
    
    def can_be_payer?
      subscriber_type == "Restaurant"
    end
    
    def staff_account?
      subscription && subscription.staff_account?
    end
    
    def premium_account
      premium_account?
    end

    def premium_account?
      subscription && subscription.premium? && subscription.active?
    end

    def complimentary_account?
      subscription.present? && subscription.complimentary?
    end

    def account_in_overtime?
      subscription.present? && subscription.in_overtime?
    end
    
    def has_braintree_account?
      subscription.present? && subscription.has_braintree_info?
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
      if subscription
        result = BraintreeConnector.cancel_subscription(subscription)
        subscription.update_attributes(:payer => payer, :braintree_id => nil)
      else
        self.subscription = Subscription.create(
            :kind => "User Premium",
            :payer => payer, 
            :start_date => Date.today,
            :braintree_id => nil)
        save
      end
      subscription

    end

    def make_complimentary!
      if can_make_complimentary_with_discount?
        make_complimentary_with_discount!
      else
        make_complimentary_with_cancel!
      end
    end

    def can_make_complimentary_with_discount?
      subscription.present? && can_be_payer? && staff_subscriptions.present?
    end
    
    def make_complimentary_with_discount!
      result = BraintreeConnector.update_subscription_with_discount(subscription)
      if result.success?
        subscription.update_attributes(:payer => nil)
      end
      subscription
    end
    
    def make_complimentary_with_cancel!
      success = cancel_subscription_from_braintree!
      if success
        update_attributes(:subscription => Subscription.create(
            :kind => "#{subscriber_type} Premium",
            :payer => nil,
            :start_date => (subscription && subscription.start_date) || Date.today,
            :braintree_id => nil))
      end
      subscription
    end
    
    def cancel_subscription_from_braintree!
      return true if subscription.blank?
      return true if subscription.skip_braintree_cancel?
      return true if subscription.braintree_id.blank?
      result = BraintreeConnector.cancel_subscription(subscription)
      if result.success?
        subscription.destroy
      end
      result.success?
    end
    
    def update_complimentary_with_braintree_id!(braintree_id)
      subscription.update_attributes(:braintree_id => braintree_id)
    end

    # note this version doesn't manage the braintree part of this...
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