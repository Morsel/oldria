class Admin::CulinarySchoolsController < Admin::AdminController
  def index
    @culinary_schools = CulinarySchool.all
  end
  
  def show
    @culinary_school = CulinarySchool.find(params[:id])
  end
  
  def new
    @culinary_school = CulinarySchool.new
  end
  
  def create
    @culinary_school = CulinarySchool.new(params[:culinary_school])
    if @culinary_school.save
      flash[:notice] = "Successfully created culinary school."
      redirect_to admin_culinary_schools_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @culinary_school = CulinarySchool.find(params[:id])
  end
  
  def update
    @culinary_school = CulinarySchool.find(params[:id])
    if @culinary_school.update_attributes(params[:culinary_school])
      flash[:notice] = "Successfully updated culinary school."
      redirect_to [:admin, @culinary_school]
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @culinary_school = CulinarySchool.find(params[:id])
    @culinary_school.destroy
    flash[:notice] = "Successfully destroyed culinary school."
    redirect_to admin_culinary_schools_url
  end
end
