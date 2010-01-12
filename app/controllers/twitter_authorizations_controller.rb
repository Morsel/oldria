class TwitterAuthorizationsController < ApplicationController
  before_filter :require_user

  def new
    clear_request_tokens
    oauth_client = current_user.twitter_oauth
    request_token = oauth_client.request_token(:oauth_callback => TWITTER_CONFIG['callbackurl'])
    session['rsecret'] = request_token.secret
    session['rtoken'] = request_token.token

    redirect_to request_token.authorize_url
  end

  def show
    begin
      twitter_oauth = current_user.twitter_oauth
      access_token = twitter_oauth.authorize(
        session['rtoken'],
        session['rsecret'],
        :oauth_verifier => params[:oauth_verifier]
      )

      if current_user.update_attributes({:atoken => access_token.token, :asecret => access_token.secret})
        clear_request_tokens
        flash[:notice] = "Cool. Your Twitter account was successfully linked to SpoonFeed."
      end

    rescue OAuth::Unauthorized
      flash[:error] = "Hmm, something went wrong. We'll sent our worker bees in to find out why."
    end

    redirect_to root_path
  end

  private

  def clear_request_tokens
    session['rtoken'] = nil
    session['rsecret'] = nil
  end
end
