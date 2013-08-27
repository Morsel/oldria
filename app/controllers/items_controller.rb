class ItemsController < ApplicationController
	before_filter :find_category, :except =>[:get_feature_keywords]

	def new
		@item = @category.items.build
	end

	def create
		 @item =@category.items.build(params[:item])
		 if @item.save
			flash[:notice] = "Your item has been saved"
      redirect_to edit_category_item_path(@category,@item)
    else
    	flash[:error] = "Please select at least one tags for item"
			render :action => "new"
		end
	end

	def edit
		@item = @category.items.find(params[:id])
		@categories_keywords = @item.restaurant_features
		@selected_keywords = @item.carte_feature_items.map(&:restaurant_feature_id)
	end

	def update
		
	end

  def get_feature_keywords
    @selected_keywords = params[:selected_keywords].split(",").map { |s| s.to_i }
    @categories_keywords = RestaurantFeature.find(:all,:conditions=>["id IN(?) OR value like ? ",@selected_keywords,"%#{params[:search_keywords]}%"],:order => "value ASC",:limit=>100)
     respond_to do |wants|
        wants.html { render :partial=>'get_feature_keywords' }
    end
  end 

	private
		def find_category
			@category = Category.find(params[:category_id])
			@carte = @category.carte
			@restaurant = @carte.restaurant
		end

end
