class MediafeedPagesController < Hq::HqController
  layout 'mediafeed'
  
  def show
    @page = MediafeedPage.find(params[:id])
  end
  
end
