class JamesBeardRegionsController < ApplicationController
	def index
    respond_to do |format|
      format.html
      format.js { auto_complete_james_beard_regions }
    end
  end	

  def auto_complete_james_beard_regions
    region_name = params[:term]
    @james_beard_region = JamesBeardRegion.find(:all,:conditions => ["name like ?", "%#{region_name}%"],:limit => 15)
    if @james_beard_region.present?
      render :json => @james_beard_region.map(&:name)
    else
      render :json => @specialty.push('This region does not yet exist in our database. Please try another region.')
    end
  end

end


