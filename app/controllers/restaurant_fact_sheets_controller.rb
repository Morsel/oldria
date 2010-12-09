class RestaurantFactSheetsController < ApplicationController
  before_filter :find_restaurant

  # GET /restaurant_fact_sheets/1
  # GET /restaurant_fact_sheets/1.xml
  def show
    @restaurant_fact_sheet = @restaurant.fact_sheet

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @restaurant_fact_sheet }
    end
  end

  # GET /restaurant_fact_sheets/1/edit
  def edit
    @restaurant_fact_sheet = @restaurant.fact_sheet
  end

  # PUT /restaurant_fact_sheets/1
  # PUT /restaurant_fact_sheets/1.xml
  def update
    @restaurant_fact_sheet = @restaurant.fact_sheet

    respond_to do |format|
      if @restaurant_fact_sheet.update_attributes(params[:restaurant_fact_sheet])
        flash[:notice] = 'RestaurantFactSheet was successfully updated.'
        format.html { redirect_to edit_restaurant_fact_sheet_path(@restaurant) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @restaurant_fact_sheet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /restaurant_fact_sheets/1
  # DELETE /restaurant_fact_sheets/1.xml
  def destroy
    @restaurant_fact_sheet = @restaurant.fact_sheet
    @restaurant_fact_sheet.destroy

    respond_to do |format|
      format.html { redirect_to(restaurant_fact_sheets_url) }
      format.xml  { head :ok }
    end
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end
