class WelcomeController < ApplicationController

  def index
    if current_user
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

  def slug_for_home_page
    mediafeed? ? 'home_media' : 'home'
  end

  def set_up_dashboard
    soapbox_comments = SoapboxEntry.published.all(:limit => 10, :order => "published_at DESC").map(&:comments)
    answers = ProfileAnswer.all(:limit => 10, :order => "created_at DESC")

    @recent_comments = [soapbox_comments, answers].flatten.sort { |a,b| b.created_at <=> a.created_at }[0..9]
  end
end
