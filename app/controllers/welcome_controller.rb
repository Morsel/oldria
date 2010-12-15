class WelcomeController < ApplicationController

  def index
    if current_user
      redirect_to mediafeed_root_path and return if current_user.media?

      @user = current_user
      set_up_dashboard
      render :dashboard
    else
      @sf_slides = SfSlide.all(:limit => 4)
      @sf_promos = SfPromo.all(:limit => 4)
      render :layout => 'home'
    end
  end

  private

  def set_up_dashboard
    soapbox_comments = SoapboxEntry.published.all(:limit => 10, :order => "published_at DESC").map(&:comments)
    answers = ProfileAnswer.all(:limit => 10, :order => "created_at DESC")

    @recent_comments = [soapbox_comments, answers].flatten.sort { |a,b| b.created_at <=> a.created_at }[0..9]
  end
end
