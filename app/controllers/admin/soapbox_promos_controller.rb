class Admin::SoapboxPromosController < Admin::AdminController

  def index
    @promos = SoapboxPromo.all(:order => "created_at DESC")
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

  def destroy
    @promo = SoapboxPromo.find(params[:id])
    @promo.destroy
    flash[:notice] = "Deleted promo \"#{@promo.title}\""
    redirect_to :action => "index"
  end

end
