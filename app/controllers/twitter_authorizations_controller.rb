class TwitterAuthorizationsController < ApplicationController
  before_filter :require_user

  def new
    clear_request_tokens

    oauth_client = current_user.twitter_oauth
    request_token = oauth_client.get_request_token(:oauth_callback => TWITTER_CONFIG['callbackurl'])
    session[:request_token] = request_token

    redirect_to request_token.authorize_url(:oauth_callback => TWITTER_CONFIG['callbackurl'])
  end

  def show
    begin
      access_token = session[:request_token].get_access_token

      if current_user.update_attributes(:atoken => access_token.token, :asecret => access_token.secret)
        clear_request_tokens
        flash[:notice] = "Cool. Your Twitter account was successfully linked to SpoonFeed."
      end

    rescue OAuth::Unauthorized
      flash[:error] = "Hmm, something went wrong. We'll sent our worker bees in to find out why."
    end

    redirect_to edit_user_profile_path(current_user)
  end

  private

  def clear_request_tokens
    session[:request_token] = nil
  end
end
