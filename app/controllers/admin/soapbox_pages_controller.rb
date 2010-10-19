class Admin::SoapboxPagesController < Admin::AdminController

  def index
    @pages = SoapboxPage.all(:order => :slug)
  end

  def show
    @page = SoapboxPage.find(params[:id])
  end

  def new
    @page = SoapboxPage.new
  end

  def create
    @page = SoapboxPage.new(params[:soapbox_page])
    if @page.save
      flash[:notice] = "Successfully created page."
      redirect_to admin_soapbox_pages_path
    else
      render :new
    end
  end

  def edit
    @page = SoapboxPage.find(params[:id])
  end

  def update
    @page = SoapboxPage.find(params[:id])
    if @page.update_attributes(params[:soapbox_page])
      flash[:notice] = "Successfully updated page."
      redirect_to admin_soapbox_pages_path(:anchor => "soapbox_page_#{@page.id}")
    else
      render :edit
    end
  end

  def destroy
    @page = SoapboxPage.find(params[:id])
    @page.destroy
    flash[:notice] = "Successfully destroyed page."
    redirect_to admin_pages_path
  end

end
