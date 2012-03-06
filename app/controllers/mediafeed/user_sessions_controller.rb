class Mediafeed::UserSessionsController < ApplicationController

  def new
    redirect_to login_url(:subdomain => "spoonfeed")
  end

end
