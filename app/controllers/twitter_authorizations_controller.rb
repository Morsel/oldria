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
    twitter_oauth = current_user.twitter_oauth
    access_token = twitter_oauth.authorize(
      session['rtoken'], 
      session['rsecret'], 
      :oauth_verifier => params[:oauth_verifier]
    )
    
    if current_user.update_attributes({:atoken => access_token.token, :asecret => access_token.secret})
      clear_request_tokens
      flash[:notice] = "Cool. Your Twitter account was successfully linked to SpoonFeed"
      redirect_to root_path
    else
      flash[:error] = "Hmm, something went wrong. We'll sent our worker bees in to find out why."
      redirect_to root_path
    end
  end
  
  private
  
  def clear_request_tokens
    session['rtoken'] = nil
    session['rsecret'] = nil
  end
end
