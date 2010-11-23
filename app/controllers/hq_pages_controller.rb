class HqPagesController < Hq::HqController
  layout 'hq'
  
#  before_filter :load_past_features, :only => [:show]
  
  def show
    @page = HqPage.find(params[:id])
  end
  
end
