class Admin::OtmKeywordsController < Admin::AdminController

  def index
    @categories = OtmKeyword.all(:order => "category ASC, name ASC").group_by(&:category)
  end

  def new
    @keyword = OtmKeyword.new
  end

  def create
    @keyword = OtmKeyword.new(params[:otm_keyword])
    if @keyword.save
      flash[:notice] = "Your keyword has been saved"
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def edit
    @keyword = OtmKeyword.find(params[:id])
  end

  def update
    @keyword = OtmKeyword.find(params[:id])
    if @keyword.update_attributes(params[:otm_keyword])
      flash[:notice] = "Your keyword has been saved"
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end

  def destroy
    @keyword = OtmKeyword.find(params[:id])
    if @keyword.destroy
      flash[:notice] = "Your keyword has been deleted"
      redirect_to :action => "index"
    end
  end

end
