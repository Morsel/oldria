class Admin::RunnerController < Admin::AdminController
  def index

  	if params[:id].to_i == 1 
  		MediaNewsletterSubscription.new.send_newsletters_to_media
  		flash[:notice] = "Newsletter sent!"
      redirect_to :action => 'index'
  	end	
  	if params[:id].to_i == 2 
  		Promotion.last.send_newsfeed_newsletters_later
  		flash[:notice] = "Promotion email sent!"
      redirect_to :action => 'index'
  	end

  end

end
