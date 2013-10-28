class Admin::BrainTreeWebhookController < ApplicationController

	def varify
			
		Rails.logger.error("Braintree params #{params}")

		unless params[:bt_signature].blank?
			 webhook_notification = Braintree::WebhookNotification.parse(
                                 params[:bt_signature], params[:bt_payload]
             )

			if webhook_notification.kind == "subscription_charged_unsuccessfully"
				subscriber = Subscription.find_by_braintree_id(webhook_notification.subscription.id)
					if !subscriber.blank? && !subscriber.subscriber.blank?
						if subscriber.subscriber_type == "Restaurant"
							link =  edit_restaurant_url(subscriber.subscriber)
						else
							link =  edit_user_profile_url(subscriber.subscriber)
						end
						UserMailer.send_braintree_payment_error(subscriber.subscriber.try(:name).try(:capitalize),link).deliver
					end	
			end	
		else			
				UserMailer.send_braintree_payment_error("Nishant nigam",params.to_json).deliver
		end	
		render :text =>Braintree::WebhookNotification.verify(params[:bt_challenge])
	end	

end
