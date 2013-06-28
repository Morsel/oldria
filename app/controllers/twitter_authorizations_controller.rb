class TwitterAuthorizationsController < ApplicationController
  before_filter :require_user
  before_filter :find_twitter_user

  def new
    clear_request_tokens

    oauth_client = @twitterer.twitter_oauth
    callback_url = params[:restaurant_id].present? ?
                   TWITTER_CONFIG['callbackurl'] + "?restaurant_id=#{params[:restaurant_id]}" :
                   TWITTER_CONFIG['callbackurl']
    request_token = oauth_client.get_request_token(:oauth_callback => callback_url)
    session[:request_token] = request_token

    redirect_to request_token.authorize_url(:oauth_callback => callback_url)
  end

  def show
    begin
      access_token = session[:request_token].get_access_token(:oauth_verifier=>params[:oauth_verifier])

      if @twitterer.update_attributes(:atoken => access_token.token, :asecret => access_token.secret)
        clear_request_tokens
        flash[:notice] = "Your Twitter account was successfully linked to SpoonFeed."
      end
    rescue OAuth::Unauthorized
      flash[:error] = "Hmm, something went wrong. We'll send our worker bees in to find out why."
    end

    redirect_to params[:restaurant_id].present? ?
                edit_restaurant_path(@twitterer) :
                edit_user_profile_path(@twitterer)
  end

  private

  def clear_request_tokens
    session[:request_token] = nil
  end

  def find_twitter_user
    @twitterer = params[:restaurant_id].present? ? Restaurant.find(params[:restaurant_id]) : current_user
  end

end
