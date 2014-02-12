class CuisinesController < ApplicationController
	def index
    respond_to do |format|
      #format.html
      format.js { auto_complete_cuisines }
    end
  end	

  def auto_complete_cuisines
    cusine_name = params[:term]
    @cusine = Cuisine.find(:all,:conditions => ["name like ?", "%#{cusine_name}%"],:limit => 15)
    if @cusine.present?
      render :json => @cusine.map(&:name)
    else
      render :json => @specialty.push('This region does not yet exist in our database. Please try another region.')
    end
  end
end
