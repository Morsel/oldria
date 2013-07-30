class SpecialtiesController < ApplicationController
	def index
    respond_to do |format|
      format.html
      format.js { auto_complete_specialties }
    end
  end	

  def auto_complete_specialties
    specialtie_name = params[:term]
    @specialty = Specialty.find(:all,:conditions => ["name like ?", "%#{specialtie_name}%"],:limit => 15)
    if @specialty.present?
      render :json => @specialty.map(&:name)
    else
      render :json => @specialty.push('This keyword does not yet exist in our database. Please try another keyword.')
    end
  end
end
