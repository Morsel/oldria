class Admin::SfPromosController < Admin::AdminController
  
  def index
    @promos = SfPromo.all(:order => :position)
  end

  def new
    @promo = SfPromo.new
  end
  
  def create
    @promo = SfPromo.new(params[:sf_promo])
    if @promo.save
      flash[:notice] = "Created new promo \"#{@promo.title}\""
      redirect_to :action => "index"
    else
      render :action => :new 
    end
  end

  def edit
    @promo = SfPromo.find(params[:id])
  end
  
  def update
    @promo = SfPromo.find(params[:id])
    if @promo.update_attributes(params[:sf_promo])
      flash[:notice] = "Updated promo \"#{@promo.title}\""
      redirect_to :action => "index"
    else
      render :action => :edit
    end      
  end
  
  def destroy
    @promo = SfPromo.find(params[:id])
    @promo.destroy
    flash[:notice] = "Deleted promo \"#{@promo.title}\""
    redirect_to :action => "index"
  end

  def sort
    if params[:sf_promos]
      params[:sf_promos].each_with_index do |id, index|
        SfPromo.update_all(['position=?', index+1], ['id=?', id])
      end      
    end
    render :nothing => true
  end
  
end
