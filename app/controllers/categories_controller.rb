class CategoriesController < ApplicationController
	before_filter :find_restaurant_carte, :except => [:update,:edit]
	before_filter :find_carte_category, :except => [:create,:new,:update]

	def new
  	@carte_category = @carte.categories.build
	end

	def update
		@carte_category = Category.find(params[:id]) 
		if @carte_category.update_attributes(params[:category])
      flash[:notice] = "Your new menu has been saved"
      redirect_to new_category_path(:carte_id=>@carte_category.carte.id)
    else
      flash[:error] = @carte_category.errors.full_messages.to_sentence
      redirect_to new_category_path(:carte_id=>@carte_category.carte.id)
    end
	end

	def destroy
    if @carte_category.destroy
    	flash[:notice] = "Your new menu category has been deleted"
	  else
    	flash[:error] = @carte_category.errors.full_messages.to_sentence
    end
    redirect_to new_restaurant_carte_carte_category_path(@restaurant,@carte)
  end

  private
  	def find_restaurant_carte
	    @carte = Carte.find(params[:carte_id])	
	    @restaurant = @carte.restaurant    
	  end

	  def find_carte_category
	  	@carte_category = Category.find(params[:id]) 
	  end

end
