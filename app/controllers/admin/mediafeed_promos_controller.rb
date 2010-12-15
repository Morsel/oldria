class Admin::MediafeedPromosController < Admin::AdminController
  
  def index
    @promos = MediafeedPromo.all(:order => :position)
  end

  def new
    @promo = MediafeedPromo.new
  end
  
  def create
    @promo = MediafeedPromo.new(params[:mediafeed_promo])
    if @promo.save
      flash[:notice] = "Created new promo \"#{@promo.title}\""
      redirect_to :action => "index"
    else
      render :action => :new 
    end
  end

  def edit
    @promo = MediafeedPromo.find(params[:id])
  end
  
  def update
    @promo = MediafeedPromo.find(params[:id])
    if @promo.update_attributes(params[:mediafeed_promo])
      flash[:notice] = "Updated promo \"#{@promo.title}\""
      redirect_to :action => "index"
    else
      render :action => :edit
    end      
  end
  
  def destroy
    @promo = MediafeedPromo.find(params[:id])
    @promo.destroy
    flash[:notice] = "Deleted promo \"#{@promo.title}\""
    redirect_to :action => "index"
  end

  def sort
    if params[:mediafeed_promos]
      params[:mediafeed_promos].each_with_index do |id, index|
        MediafeedPromo.update_all(['position=?', index+1], ['id=?', id])
      end      
    end
    render :nothing => true
  end
  
end
