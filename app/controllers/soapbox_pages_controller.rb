class SoapboxPagesController < Soapbox::SoapboxController
  
  before_filter :load_past_features, :only => [:show]
  
  def show
    @page = SoapboxPage.find(params[:id])
  end

end
