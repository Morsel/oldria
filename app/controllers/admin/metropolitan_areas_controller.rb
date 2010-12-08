class Admin::MetropolitanAreasController < ApplicationController
  
  def index
    @metros = MetropolitanArea.all
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

end
