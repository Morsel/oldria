class Admin::RestaurantRolesController < Admin::AdminController
  
  def index
    @restaurant_roles = RestaurantRole.all
    @categories = RestaurantRole.categories
    respond_to do |format|
      format.js { render :text => RestaurantRole.find(:all, 
        :conditions => ["category like ?", "%#{params[:q]}%"]).map(&:category).uniq.join("\n") if params[:q] }
      format.html {}
    end
  end

  def new
    @restaurant_role = RestaurantRole.new
  end

  def create
    @restaurant_role = RestaurantRole.new(params[:restaurant_role])
    if @restaurant_role.save
      flash[:notice] = "Successfully created restaurant role."
      redirect_to admin_restaurant_roles_path
    else
      render :new
    end
  end

  def edit
    @restaurant_role = RestaurantRole.find(params[:id])
  end

  def update
    @restaurant_role = RestaurantRole.find(params[:id])
    if @restaurant_role.update_attributes(params[:restaurant_role])
      flash[:notice] = "Successfully updated restaurant role."
      redirect_to admin_restaurant_roles_path
    else
      render :edit
    end
  end

  def destroy
    @restaurant_role = RestaurantRole.find(params[:id])
    @restaurant_role.destroy
    flash[:notice] = "Successfully destroyed restaurant role."
    redirect_to admin_restaurant_roles_path
  end
  
  def update_category
    @role = RestaurantRole.find(params[:role_id])
    @role.update_attributes(params[:restaurant_role])
    flash[:notice] = "Updated category"
    redirect_to :action => "index"
  end
  
end
