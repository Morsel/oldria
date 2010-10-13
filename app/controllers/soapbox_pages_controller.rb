class SoapboxPagesController < ApplicationController
  
  layout 'soapbox'
  
  def show
    @page = SoapboxPage.find(params[:id])
  end

end
