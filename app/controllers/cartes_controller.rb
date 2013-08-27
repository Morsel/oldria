class CartesController < ApplicationController
	before_filter :require_user
	before_filter :find_restaurant
	before_filter :find_carte, :except => [:index,:create,:new]
	before_filter :require_account_manager_authorization, :except => [:index]

  def index
    @cartes = @restaurant.cartes.all(:order => "created_at DESC").paginate(:page => params[:page], :per_page => 10)
    render :template => "cartes/media_user/index" if cannot?(:edit, @restaurant)
  end

  def new
  	@carte = @restaurant.cartes.build
  	@carte.categories.build
  	@carte.days_of_weeks.build  	
  end

  def create
  	@carte = @restaurant.cartes.build(params[:carte])
    if @carte.save
      flash[:notice] = "Your new menu has been saved"
      redirect_to :action => "edit", :id => @carte.id
    else
			render :action => "new"
    end
  end

  def edit
  end

  def update 
    #delete a new attribute hash that not required here
    params[:carte][:categories_attributes] = params[:carte][:categories_attributes].except(:new_categories) if params[:carte][:categories_attributes].present?
    if @carte.update_attributes(params[:carte])
      flash[:notice] = "Your new menu has been saved"
      redirect_to :action => "edit"
    else
      flash[:error] = @carte.errors.full_messages.to_sentence
      render :action => "edit"
    end
  end

  def show
  end

  def destroy
    if @carte.destroy
      flash[:notice] = "Your new menu has been deleted"
      redirect_to :action => "index"
    end
  end

private

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def find_carte
  	@carte = @restaurant.cartes.find(params[:id])
  end

end
