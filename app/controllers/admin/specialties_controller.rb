class Admin::SpecialtiesController < Admin::AdminController
  
  def index
    @specialties = Specialty.all(:order => :position)
  end
  
  def new
    @specialty = Specialty.new
  end
  
  def create
    @specialty = Specialty.new(params[:specialty])
    if @specialty.save
      flash[:notice] = "Created specialty \"#{@specialty.name}\""
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end
  
  def edit
    @specialty = Specialty.find(params[:id])
  end
  
  def update
    @specialty = Specialty.find(params[:id])
    
    if @specialty.update_attributes(params[:specialty])
      flash[:notice] = "Updated specialty \"#{@specialty.name}\""
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @specialty = Specialty.find(params[:id])
    flash[:notice] = "Deleted specialty \"#{@specialty.name}\""
    @specialty.destroy
    redirect_to :action => "index"
  end
  
  def sort
    if params[:specialties]
      params[:specialties].each_with_index do |id, index|
        Specialty.update_all(['position=?', index+1], ['id=?', id])
      end      
    end
    render :nothing => true
  end
  
end
