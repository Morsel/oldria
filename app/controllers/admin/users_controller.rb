class Admin::UsersController < Admin::AdminController
  # GET /admin/users
  # GET /admin/users.xml
  def index
    @search = User.search(params[:search])
    @users = @search.all(:order => :last_name)

    respond_to do |format|
      format.html { flash.now[:notice] = "We couldn't find anything" if @users.blank? }
      format.xml  { render :xml => @admin_users }
    end
  end

  # GET /admin/users/1
  # GET /admin/users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /admin/users/new
  # GET /admin/users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /admin/users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /admin/users
  # POST /admin/users.xml
  def create
    @user = User.new(params[:user])
    @user.admin = params[:user].delete(:admin)
    respond_to do |format|
      if (@user.confirmed_at = Time.now) && @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to admin_users_path(:anchor => dom_id(@user)) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :new }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/users/1
  # PUT /admin/users/1.xml
  def update
    @user = User.find(params[:id])
    @user.admin = params[:user].delete(:admin)
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(admin_users_url) }
        format.xml  { head :ok }
      else
        format.html { render :edit }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/users/1
  # DELETE /admin/users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(admin_users_url) }
      format.xml  { head :ok }
      format.js   { head :ok }
    end
  end

  def impersonator 
    session = UserSession.find
    #session.destroy
    user = User.find(params[:id])   
    if UserSession.create(user).valid?
      flash[:notice] = "Your are logged in as #{user.try(:name)}"
      restaurant = user.restaurants.map{|restaurant| restaurant unless restaurant.count.nil? }.compact.first
      unless restaurant.blank?
        flash[:error] = "Last time you are try to upgrade your #{restaurant.name} but payment was not successfully due to some reason. You can upgrade your account by <a href='/restaurants/#{restaurant.id}/subscription/new' >click here</a>"
        redirect_to edit_restaurant_path(restaurant)
      end
      redirect_to root_path
    else
      flash[:error] = "#{user.try(:name)} has not activated his account."
      redirect_to admin_users_path
    end  
  end  
end
