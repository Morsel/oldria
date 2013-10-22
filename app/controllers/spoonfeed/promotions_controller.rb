class Spoonfeed::PromotionsController < ApplicationController

  before_filter :require_user
  require 'will_paginate/array'
  
  def index
    @promotions = Promotion.from_premium_restaurants.all(:order => "created_at DESC").paginate(:page => params[:page])
  end

end
