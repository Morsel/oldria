class SoapboxPagesController < Soapbox::SoapboxController
  
  def show
    @page = SoapboxPage.find(params[:id])
    @no_sidebar = true
  end

end
