class Admin::SubjectMattersController < Admin::AdminController
  def index
    @subject_matters = SubjectMatter.all
  end

  def show
    @subject_matter = SubjectMatter.find(params[:id])
  end

  def new
    @subject_matter = SubjectMatter.new
  end

  def create
    @subject_matter = SubjectMatter.new(params[:subject_matter])
    if @subject_matter.save
      flash[:notice] = "Successfully created subject matter."
      redirect_to admin_subject_matters_url
    else
      render :new
    end
  end

  def edit
    @subject_matter = SubjectMatter.find(params[:id])
  end

  def update
    @subject_matter = SubjectMatter.find(params[:id])
    if @subject_matter.update_attributes(params[:subject_matter])
      flash[:notice] = "Successfully updated subject matter."
      redirect_to admin_subject_matters_url
    else
      render :edit
    end
  end

  def destroy
    @subject_matter = SubjectMatter.find(params[:id])
    @subject_matter.destroy
    flash[:notice] = "Successfully destroyed subject matter."
    redirect_to admin_subject_matters_url
  end
end
