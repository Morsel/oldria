class Admin::BrainTreeWebhookController < Admin::AdminController

	def varify
			render :text =>Braintree::WebhookNotification.verify(params[:bt_challenge])
	end	
end
