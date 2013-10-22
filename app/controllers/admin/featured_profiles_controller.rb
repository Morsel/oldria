class Admin::FeaturedProfilesController < Admin::AdminController
	before_filter :get_feature_profile
	before_filter :preimum_user_and_restaurant ,:only=>[:create,:new,:edit,:update]	


	def index
  		@featured_profiles = FeaturedProfile.valid_feature_profiles
  end

  def new  	
      @feature = eval(params[:type].capitalize).new.build_featured_profile
  end	
  def edit
      @feature = ::FeaturedProfile.find(params[:id])     
  end 
  def update      
      @feature = ::FeaturedProfile.find(params[:id])    
      if @feature.update_attributes(params[:featured_profile])
        flash[:notice] = "Successfully updated featured profile ."
        redirect_to :action => 'index'
      else
       render :action => 'edit',:type => params[:type]
    end
  end  
  def destroy

      ::FeaturedProfile.find(params[:id]).destroy
      render :js => ''
  end 

  def create
  	@feature = eval(params[:type].capitalize).new.build_featured_profile(params[:featured_profile]) # TODO need to remove as this is already in before filter :(
  	if @feature.save      
  		flash[:notice] = "Successfully created profile spotlight ."
      redirect_to :action => 'index'
  	else	
  		render :new
  	end
  end

  private
  def get_feature_profile
  	#@features = FeaturedProfile.all
  end
  def preimum_user_and_restaurant 
  		if params[:type].present? &&  ['user','restaurant'].include?(params[:type].downcase) 
        # @records = eval(params[:type].capitalize).premium_account
        @records = params[:type].capitalize=="User" ? User.all.map{|u| u if u.premium_account}.compact : Restaurant.all.map{|u| u if u.premium_account}.compact
       else
        redirect_to :action => 'index' 
  		end	
  end	


end
