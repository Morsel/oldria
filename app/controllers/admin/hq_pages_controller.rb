class Admin::HqPagesController < Admin::AdminController

  def index
    @pages = HqPage.all(:order => :slug)
  end

  def show
    @page = HqPage.find(params[:id])
  end

  def new
    @page = HqPage.new
  end

  def create
    @page = HqPage.new(params[:hq_page])
    if @page.save
      flash[:notice] = "Successfully created page."
      redirect_to admin_hq_pages_path
    else
      render :new
    end
  end

  def edit
    @page = HqPage.find(params[:id])
  end

  def update
    @page = HqPage.find(params[:id])
    if @page.update_attributes(params[:hq_page])
      flash[:notice] = "Successfully updated page."
      redirect_to admin_hq_pages_path(:anchor => "hq_page_#{@page.id}")
    else
      render :edit
    end
  end

  def destroy
    @page = HqPage.find(params[:id])
    @page.destroy
    flash[:notice] = "Successfully destroyed page."
    redirect_to admin_hq_pages_path
  end

end
