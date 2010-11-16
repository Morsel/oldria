class Soapbox::SoapboxController < ApplicationController
  
  before_filter :load_past_features, :only => [:index, :directory]
  
  layout 'soapbox'
  
  def index
    @home = true
    @slides = SoapboxSlide.all(:order => "position", :limit => 4, :conditions => "position is not null")
    @promos = SoapboxPromo.all(:order => "position", :limit => 3, :conditions => "position is not null")
  end

  def directory
    if params[:specialty_id]
      @specialty = Specialty.find(params[:specialty_id])
      @users = User.in_soapbox_directory.profile_specialties_id_eq(params[:specialty_id]).all(:order => "users.last_name").uniq
    elsif params[:cuisine_id]
      @cuisine = Cuisine.find(params[:cuisine_id])
      @users = User.in_soapbox_directory.profile_cuisines_id_eq(params[:cuisine_id]).all(:order => "users.last_name").uniq
    else
      directory_search_setup
      
      @use_search = true
      @users_for_search = User.in_soapbox_directory
      @restaurants_for_search = @users_for_search.map(&:restaurants).flatten.compact.uniq.sort { |a,b| a.sort_name <=> b.sort_name }
    end
    
    render :template => "directory/index"
  end
  
  def directory_search
    directory_search_setup
    render :partial => "directory/search_results"
  end

end
