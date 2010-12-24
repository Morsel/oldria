class Admin::MediafeedPagesController < Admin::AdminController

  def index
    @pages = MediafeedPage.all(:order => :slug)
  end

  def show
    @page = MediafeedPage.find(params[:id])
  end

  def new
    @page = MediafeedPage.new
  end

  def create
    @page = MediafeedPage.new(params[:mediafeed_page])
    if @page.save
      flash[:notice] = "Successfully created page."
      redirect_to admin_mediafeed_pages_path
    else
      render :new
    end
  end

  def edit
    @page = MediafeedPage.find(params[:id])
  end

  def update
    @page = MediafeedPage.find(params[:id])
    if @page.update_attributes(params[:mediafeed_page])
      flash[:notice] = "Successfully updated page."
      redirect_to admin_mediafeed_pages_path(:anchor => "mediafeed_page_#{@page.id}")
    else
      render :edit
    end
  end

  def destroy
    @page = MediafeedPage.find(params[:id])
    @page.destroy
    flash[:notice] = "Successfully destroyed page."
    redirect_to admin_mediafeed_pages_path
  end

end
