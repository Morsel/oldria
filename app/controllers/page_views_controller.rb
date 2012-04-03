class PageViewsController < ApplicationController

  def create
    page_view = PageView.create(params[:page_view])
    respond_to do |format|
      format.js { render :json => page_view }
    end
  end

end
