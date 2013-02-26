class Admin::BrainTreeWebhookController < ApplicationController

	def varify
			
		Rails.logger.error("Braintree params #{params}")

		unless params[:bt_signature].blank?
				webhook_notification = Braintree::WebhookNotification.parse(
				  params[:bt_signature], params[:bt_payload]
				)
				
				if webhook_notification.kind == "subscription_charged_unsuccessfully"
						subscriber = Subscription.find_by_braintree_id(webhook_notification.subscription.id)
						unless subscriber.blank?
							UserMailer.deliver_send_payment_error(subscriber.subscriber.try(:name).try(:capitalize),"Subscription get failed")
						end	
				end	
			else
				UserMailer.deliver_send_payment_error("Nishant nigam","Brain tree code get faild, Please  frwd to nishant")
		end	
			render :text =>Braintree::WebhookNotification.verify(params[:bt_challenge])
	end	

	
end
