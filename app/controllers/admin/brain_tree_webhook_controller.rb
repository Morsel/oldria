class Admin::BrainTreeWebhookController < ApplicationController

	def varify
			render :text =>Braintree::WebhookNotification.verify(params[:bt_challenge])
	end	

	
end
