class Admin::CuisinesController < Admin::AdminController
  # GET /admin_cuisines
  # GET /admin_cuisines.xml
  def index
    @cuisines = Cuisine.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cuisines }
    end
  end

  # GET /admin_cuisines/new
  # GET /admin_cuisines/new.xml
  def new
    @cuisine = Cuisine.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cuisine }
    end
  end

  # GET /admin_cuisines/1/edit
  def edit
    @cuisine = Cuisine.find(params[:id])
  end

  # POST /admin_cuisines
  # POST /admin_cuisines.xml
  def create
    @cuisine = Cuisine.new(params[:cuisine])

    respond_to do |format|
      if @cuisine.save
        flash[:notice] = 'Cuisine was successfully created.'
        format.html { redirect_to admin_cuisines_path }
        format.xml  { render :xml => @cuisine, :status => :created, :location => @cuisine }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cuisine.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin_cuisines/1
  # PUT /admin_cuisines/1.xml
  def update
    @cuisine = Cuisine.find(params[:id])

    respond_to do |format|
      if @cuisine.update_attributes(params[:cuisine])
        flash[:notice] = 'Cuisine was successfully updated.'
        format.html { redirect_to admin_cuisines_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cuisine.errors, :status => :unprocessable_entity }
      end
    end
  end
end
