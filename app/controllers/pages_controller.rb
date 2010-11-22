class PagesController < ApplicationController
  use_layout :ria_or_spoonfeed
  
  def show
    @page = Page.find(params[:id])
  end
  
  private
  
  def ria_or_spoonfeed
    request.subdomains.include?('spoonfeed') ? 'spoonfeed' : 'ria'
  end
end
