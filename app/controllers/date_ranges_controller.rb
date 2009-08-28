class DateRangesController < ApplicationController
  layout 'admin'

  before_filter :require_admin

  def index
    @date_ranges = DateRange.all
  end
  
  def show
    @date_range = DateRange.find(params[:id])
  end
  
  def new
    @date_range = DateRange.new
  end
  
  def create
    @date_range = DateRange.new(params[:date_range])
    if @date_range.save
      flash[:notice] = "Successfully created date range."
      redirect_to @date_range
    else
      render :action => 'new'
    end
  end
  
  def edit
    @date_range = DateRange.find(params[:id])
  end
  
  def update
    @date_range = DateRange.find(params[:id])
    if @date_range.update_attributes(params[:date_range])
      flash[:notice] = "Successfully updated date range."
      redirect_to @date_range
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @date_range = DateRange.find(params[:id])
    @date_range.destroy
    flash[:notice] = "Successfully destroyed date range."
    redirect_to date_ranges_url
  end
end
