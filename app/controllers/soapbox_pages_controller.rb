class SoapboxPagesController < Soapbox::SoapboxController
  
  def show
    @page = SoapboxPage.find(params[:id])
  end

end
