module HasSubscription

  def has_subscription
    has_one :subscription, :as => :subscriber
    has_many :paid_subscriptions, :class_name => "Subscription", :as => :payer
    after_update :update_braintree_contact_info

    scope :with_premium_account, {:include => :subscription,
      :conditions => ["subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
          Date.today]}

    include InstanceMethods
  end

  module InstanceMethods
    def braintree_customer_id
      "#{self.class}_#{self.id}"
    end

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

    def payer
      return nil unless subscription
      subscription.payer
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

      # Update all premium accounts to public (for soapbox and mediafeed)
      self.is_a?(Restaurant) ? self.write_preference(:publish_profile, true) : self.update_attribute(:publish_profile, true)

      save
      self.subscription
    end

    def update_premium!(bt_subscription)
      return make_premium!(bt_subscription) unless subscription.present?
      self.subscription.update_attributes(
          :payer => self,
          :braintree_id => bt_subscription.subscription.id)
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
      elsif can_make_complimentary_with_add_on?
        make_complimentary_with_add_on!
      else
        make_complimentary_with_cancel!
      end
    end

    def can_make_complimentary_with_discount?
      subscription.present? && can_be_payer? && staff_subscriptions.present?
    end

    def can_make_complimentary_with_add_on?
      subscription.present? && can_be_staff? && staff_account?
    end

    def make_complimentary_with_add_on!
      result = BraintreeConnector.set_add_ons_for_subscription(
          subscription.payer.subscription,
          subscription.user_subscriptions_for_payer.size - 1)
      if result.success?
        subscription.update_attributes(:payer => nil)
      end
      subscription
    end

    def make_complimentary_with_discount!
      result = BraintreeConnector.update_subscription_with_discount(subscription)
      if result.success?
        subscription.update_attributes(:payer => nil)
      end
      subscription
    end

    def make_complimentary_with_cancel!
      start_date = (subscription && subscription.start_date)
      success = cancel_braintree_subscription!
      if success
        update_attributes(:subscription => Subscription.create(
            :kind => "#{subscriber_type} Premium",
            :payer => nil,
            :start_date => start_date || Date.today,
            :braintree_id => nil))
      end
      subscription
    end

    def cancel_braintree_subscription!
      return true if subscription.blank?
      if subscription.skip_braintree_cancel? || subscription.braintree_id.blank?
        result = true
      else
        braintree_result = BraintreeConnector.cancel_subscription(subscription)
        # 81905 => braintree code for the subscription is already cancelled

        result = braintree_result.success? || braintree_result.errors.collect(&:code).include?("81905")
      end
      if result
        cancel_and_terminate_immediately
      end
      result
    end

    def update_complimentary_with_braintree_id!(braintree_id)
      subscription.update_attributes(:braintree_id => braintree_id)
    end

    # note this version doesn't manage the braintree part of this...
    def cancel_subscription!(options)
      raise "Specify a cancel subscription method" if options[:terminate_immediately].nil?
      if options[:terminate_immediately]
        cancel_and_terminate_immediately
      else
        cancel_and_terminate_gracefully
      end
    end

    def cancel_and_terminate_immediately
      subscription.destroy if subscription.present?
      if can_be_payer?
        subscription.user_subscriptions_for_payer.each do |sub|
          sub.subscriber.subscription = nil
          sub.destroy
        end
      end
      self.subscription = nil
    end

    def cancel_and_terminate_gracefully
      new_end_date = subscription.calculate_end_date
      subscription.update_attributes(:end_date => new_end_date)
      if can_be_payer?
        subscription.user_subscriptions_for_payer.each do |sub|
          sub.update_attributes(:end_date => new_end_date)
        end
      end
    end

    def admin_cancel
      if staff_account?
        success = payer.subscription.remove_staff_account(self)
      else
        success = cancel_braintree_subscription!
      end
      success
    end

    private
    def update_braintree_contact_info
      if self.is_a? User
        if self.email_changed? || self.last_name_changed? || self.first_name_changed?
          if self.subscription
            update_braintree_customer(self)
          end

          unless self.managed_restaurants.empty?
            self.managed_restaurants.each do |restaurant|
              update_braintree_customer(restaurant)
            end
          end
        end
      end

      if self.is_a? Restaurant
        if self.name_changed? || self.manager_id_changed?
          update_braintree_customer(self)
        end
      end
    end

    def update_braintree_customer(customer)
      if customer.subscription && customer.subscription.has_braintree_info?
        BraintreeConnector.update_customer(customer)
      end
    end
  end
end

ActiveRecord::Base.extend(HasSubscription)