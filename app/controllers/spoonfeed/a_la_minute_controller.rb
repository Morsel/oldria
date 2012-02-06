class Spoonfeed::ALaMinuteController < ApplicationController

  before_filter :require_user

  def index
    @answers = ALaMinuteAnswer.from_premium_responders.all(:order => "created_at DESC").paginate(:page => params[:page])
  end

end
