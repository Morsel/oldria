class WelcomeController < ApplicationController
  def index
    if current_user
      @user = current_user
      @direct_messages = @user.direct_messages.all(:joins => :sender)
      @sent_messages = @user.sent_direct_messages.all(:joins => :receiver)
      render :dashboard
    else
      # render index.html
    end
  end
  
  def dashboard
    # render dashboard.html
  end
end
