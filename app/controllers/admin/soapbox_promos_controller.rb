class Admin::SoapboxPromosController < Admin::AdminController

  def index
    @promos = SoapboxPromo.all(:order => :position)
  end

  def new
    @promo = SoapboxPromo.new
  end
  
  def create
    @promo = SoapboxPromo.new(params[:soapbox_promo])
    if @promo.save
      flash[:notice] = "Created new promo \"#{@promo.title}\""
      redirect_to :action => "index"
    else
      render :action => :new 
    end
  end

  def edit
    @promo = SoapboxPromo.find(params[:id])
  end
  
  def update
    @promo = SoapboxPromo.find(params[:id])
    if @promo.update_attributes(params[:soapbox_promo])
      flash[:notice] = "Updated promo \"#{@promo.title}\""
      redirect_to :action => "index"
    else
      render :action => :edit
    end      
  end
  
  def destroy
    @promo = SoapboxPromo.find(params[:id])
    @promo.destroy
    flash[:notice] = "Deleted promo \"#{@promo.title}\""
    redirect_to :action => "index"
  end

  def sort
    if params[:soapbox_promos]
      params[:soapbox_promos].each_with_index do |id, index|
        SoapboxPromo.update_all(['position=?', index+1], ['id=?', id])
      end      
    end
    render :nothing => true
  end
  
end
