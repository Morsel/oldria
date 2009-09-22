class WelcomeController < ApplicationController
  def index
    if current_user
      @user = current_user
      @direct_messages = @user.direct_messages.all_not_from_admin(:joins => :sender)
      @sent_messages = @user.sent_direct_messages.all(:joins => :receiver)
      @admin_direct_messages = @user.direct_messages.all_from_admin
      render :dashboard
    else
      # render index.html
    end
  end
  
  def dashboard
    # render dashboard.html
  end
end
