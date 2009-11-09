class Admin::RestaurantRolesController < Admin::AdminController
  def index
    @restaurant_roles = RestaurantRole.all
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
end
