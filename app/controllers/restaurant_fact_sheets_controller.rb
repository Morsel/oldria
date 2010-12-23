class RestaurantFactSheetsController < ApplicationController
  before_filter :find_restaurant

  # GET /restaurant_fact_sheets/1
  # GET /restaurant_fact_sheets/1.xml
  def show

    @fact_sheet = @restaurant.fact_sheet

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @fact_sheet }
    end
  end

  # GET /restaurant_fact_sheets/1/edit
  def edit
    @fact_sheet = @restaurant.fact_sheet
  end

  # PUT /restaurant_fact_sheets/1
  # PUT /restaurant_fact_sheets/1.xml
  def update
    @fact_sheet = @restaurant.fact_sheet

    respond_to do |format|
      if @fact_sheet.update_attributes(params[:restaurant_fact_sheet])
        flash[:notice] = 'RestaurantFactSheet was successfully updated.'
        format.html { redirect_to edit_restaurant_fact_sheet_path(@restaurant) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @fact_sheet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /restaurant_fact_sheets/1
  # DELETE /restaurant_fact_sheets/1.xml
  def destroy
    @fact_sheet = @restaurant.fact_sheet
    @fact_sheet.destroy
ac
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
