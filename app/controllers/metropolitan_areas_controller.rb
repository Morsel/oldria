class MetropolitanAreasController < ApplicationController
	def index
    respond_to do |format|
      format.html
      format.js { auto_complete_metro_politan_areas }
    end
  end	

  def auto_complete_metro_politan_areas
  	metro_politan_area_name = params[:term]
    @metro_politan_area = MetropolitanArea.find(:all,:conditions => ["name like ?", "%#{metro_politan_area_name}%"],:limit => 15)
    if @metro_politan_area.present?
      render :json => @metro_politan_area.map(&:name)
    else
      render :json => @metro_politan_area.push('This region does not yet exist in our database. Please try another region.')
    end
  end
end
