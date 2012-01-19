class MediafeedPagesController < Hq::HqController
  layout 'application'
  
  def show
    @page = MediafeedPage.find(params[:id])
  end
  
end
