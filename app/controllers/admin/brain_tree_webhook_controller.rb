class Admin::BrainTreeWebhookController < ApplicationController
 include SubscriptionsControllerHelper
	
	def varify
		unless params[:bt_signature].blank?
			 webhook_notification = Braintree::WebhookNotification.parse(
                                 params[:bt_signature], params[:bt_payload]
             )
			subscriber = Subscription.find_by_braintree_id(webhook_notification.subscription.id)
 			if webhook_notification.kind == "subscription_charged_unsuccessfully"
					if !subscriber.blank? && !subscriber.subscriber.blank?
			  		if subscriber.subscriber_type == "Restaurant"
							link =  edit_restaurant_url(subscriber.subscriber)
						else
							link =  edit_user_profile_url(subscriber.subscriber)
						end
						subscriber.subscriber.increment!(:error_count) 
					  @value = get_counter_msg(subscriber.subscriber.error_count) 
					  UserMailer.deliver_send_braintree_payment_error(subscriber.subscriber,@value)
					end	
			elsif  webhook_notification.kind == "subscription_charged_successfully"
				if subscriber.present? && subscriber.subscriber.present?
					subscriber.subscriber.update_attributes(:error_count=>0)
					billing_period_end_date = webhook_notification.instance_values["subject"][:subscription][:billing_period_end_date]
					billing_period_start_date  = webhook_notification.instance_values["subject"][:subscription][:billing_period_start_date]
					current_billing_cycle = webhook_notification.instance_values["subject"][:subscription][:current_billing_cycle]
					paid_through_date = webhook_notification.instance_values["subject"][:subscription][:paid_through_date]
					next_billing_date = webhook_notification.instance_values["subject"][:subscription][:next_billing_date]
					first_billing_date  = webhook_notification.instance_values["subject"][:subscription][:first_billing_date ]
					failure_count =  webhook_notification.instance_values["subject"][:subscription][:failure_count]
					subscriber.update_attributes(:billing_period_end_date=>billing_period_end_date,:billing_period_start_date=>billing_period_start_date,:current_billing_cycle=>current_billing_cycle,:paid_through_date=>paid_through_date,:next_billing_date=>next_billing_date,:first_billing_date=>first_billing_date,:failure_count=>failure_count)
			  end
			elsif webhook_notification.kind == "subscription_canceled"
				if subscriber.present? && subscriber.subscriber.present?
          subscriber.subscriber.cancel_and_terminate_gracefully
   				UserMailer.deliver_send_braintree_subscription_canceled(subscriber.subscriber)
				end 	
			end			
		end	
		render :text =>Braintree::WebhookNotification.verify(params[:bt_challenge])
	end	


		


end


