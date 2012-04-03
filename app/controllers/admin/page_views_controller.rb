class Admin::PageViewsController < Admin::AdminController

  def index
    @page_views = PageView.all(:order => "created_at DESC").paginate(:page => params[:page])
  end

end
