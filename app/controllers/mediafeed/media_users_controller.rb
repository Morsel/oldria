class Mediafeed::MediaUsersController < Mediafeed::MediafeedController
  before_filter :require_media_user, :only => [:edit, :update,:get_keywords]
   before_filter :authorize, :only => [:edit, :update]
  def new
    @user = User.new(params[:user])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      @user.has_role! :media
      @user.reset_perishable_token!
      UserMailer.deliver_signup(@user)
      redirect_to confirm_mediafeed_media_user_path(@user)
    else
      get_newsletter_data
      render :new
    end
  end

  def edit    
    get_newsletter_data    
  end

  def update
    @user = User.find(params[:id]) 
    @user.user_keywords.map(&:update_user_keyword) # Hack updated user_keywords column deleted_at

    if @user.update_attributes(params[:user])
      @user.newsfeed_promotion_types.destroy_all if @user.newsfeed_writer.blank? #Deleting regiona promotion if user is not newsfeed regional writer
      update_newsletter_data(params[:id])
      @user.send_later(:update_media_newsletter_mailchimp)
      @user.user_keywords.map(&:delete_user_old_keywords)
      flash[:notice] = "Successfully updated your profile."
      redirect_to edit_mediafeed_media_user_path(@user)
    else
      @user = User.find(params[:id])  
      get_newsletter_data
      flash[:error] = "Your profile could not be saved. Please review the errors below."
      render :edit
    end
  end

  def confirm
    @user = User.find(params[:id])
  end

  def resend_confirmation
    render :template => 'users/resend_confirmation'
  end

  def forgot_password
    render :template => 'password_resets/new'
  end

  def get_cities
      @selected_cities = []
      @cities = MetropolitanArea.find_all_by_state(params['state_name'])      
      @selected_cities = params[:user_id].blank? ? (current_user.metropolitan_areas if current_user) : (User.find(params[:user_id]).metropolitan_areas)
      render :layout => false
  end

  def get_selected_cities
    @user = User.find(params[:user_id])
    @cities = MetropolitanArea.find_all_by_state(params['state_name'])
    @checked_city = MetropolitanArea.find(:all,:conditions=>["id IN(?)",params[:checked_city].split(",").map { |s| s.to_i } ])
    @cities = ( @checked_city + @cities ).uniq
    
    render :layout => false
  end
  
  def get_keywords
    keyword_name = params[:keyword]
    @user = User.find(params[:user_id])
    @keywords = Restaurant.find(:all,:conditions => ["name like ?", "#{keyword_name}%"],:limit => 4) +OtmKeyword.find(:all,:conditions => ["name like ?", "%#{keyword_name}%"],:limit => 4) + RestaurantFeature.find(:all,:conditions => ["value like ?", "%#{keyword_name}%"],:limit => 4) + Cuisine.find(:all,:conditions => ["name like ?", "%#{keyword_name}%"],:limit => 4)
    @checked_restaurants = params[:checked][:restaurant]
    @checked_otm_keywords = params[:checked][:otmkeyword]
    @checked_cuisines = params[:checked][:cuisine]
    @checked_features = params[:checked][:restaurantfeature]

    @selected_keywords = Restaurant.find(:all,:conditions => ["id  in (?) ", params[:checked][:restaurant]]) +OtmKeyword.find(:all,:conditions => ["id  in (?) ", params[:checked][:otmkeyword]]) + RestaurantFeature.find(:all,:conditions => ["id  in (?) ", params[:checked][:restaurantfeature]]) + Cuisine.find(:all,:conditions => ["id  in (?) ", params[:checked][:cuisine]])
    @keywords = (@selected_keywords + @keywords).uniq

    respond_to do |format|
      format.html 
      format.js   { render :layout => false }
    end  
  end  

  private

  def authorize 
    @user = User.find(params[:id])  
    if (cannot? :edit, @user) || (cannot? :update, @user)
      flash[:error] = "You don't have permission to access that page"
      redirect_to @user and return
    end
  end

end

