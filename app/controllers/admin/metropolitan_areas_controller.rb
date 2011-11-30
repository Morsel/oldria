class Admin::MetropolitanAreasController < Admin::AdminController
  
  def index
    @metros = MetropolitanArea.all
  end
  
  def new
    @metro = MetropolitanArea.new
  end

  def create
    @metro = MetropolitanArea.new(params[:metropolitan_area])
    if @metro.save
      flash[:notice] = "Successfully created metro area #{@metro.name}"
      redirect_to admin_metropolitan_areas_url
    else
      render :action => 'new'
    end
  end

  def edit
    @metro = MetropolitanArea.find(params[:id])
  end
  
  def update
    @metro = MetropolitanArea.find(params[:id])
    @metro.update_attributes(params[:metropolitan_area])
    flash[:notice] = "Updated #{@metro.name}"
    redirect_to :action => "index"
  end

  def destroy
    @metro = MetropolitanArea.find(params[:id])
    @metro.destroy
    flash[:notice] = "Deleted #{@metro.name}"
    redirect_to :action => "index"    
  end

end
