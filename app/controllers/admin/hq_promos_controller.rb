class Admin::HqPromosController < Admin::AdminController
  
  def index
    @promos = HqPromo.all(:order => :position)
  end

  def new
    @promo = HqPromo.new
  end
  
  def create
    @promo = HqPromo.new(params[:hq_promo])
    if @promo.save
      flash[:notice] = "Created new promo \"#{@promo.title}\""
      redirect_to :action => "index"
    else
      render :action => :new 
    end
  end

  def edit
    @promo = HqPromo.find(params[:id])
  end
  
  def update
    @promo = HqPromo.find(params[:id])
    if @promo.update_attributes(params[:hq_promo])
      flash[:notice] = "Updated promo \"#{@promo.title}\""
      redirect_to :action => "index"
    else
      render :action => :edit
    end      
  end
  
  def destroy
    @promo = HqPromo.find(params[:id])
    @promo.destroy
    flash[:notice] = "Deleted promo \"#{@promo.title}\""
    redirect_to :action => "index"
  end

  def sort
    if params[:hq_promos]
      params[:hq_promos].each_with_index do |id, index|
        HqPromo.update_all(['position=?', index+1], ['id=?', id])
      end      
    end
    render :nothing => true
  end
  
end
