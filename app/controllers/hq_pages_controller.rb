class HqPagesController < Hq::HqController
  layout 'hq'
  
  def show
    @page = HqPage.find(params[:id])
  end
  
end
