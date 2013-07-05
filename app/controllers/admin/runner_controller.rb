class Admin::RunnerController < Admin::AdminController
  def index

  	if params[:id].to_i == 1 
  		MediaNewsletterSubscription.new.send_newsletters_to_media
  		flash[:notice] = "Newsletter sent!"
  	end	

  end

end
