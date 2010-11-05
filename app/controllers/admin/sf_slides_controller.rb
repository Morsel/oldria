class Admin::SfSlidesController < Admin::AdminController

  def index
    @slides = SfSlide.all(:order => :position)
  end
  
  def new
    @slide = SfSlide.new
  end
  
  def create
    @slide = SfSlide.new(params[:sf_slide])
    if @slide.save
      flash[:notice] = "Created new slide \"#{@slide.title}\""
      redirect_to :action => "index"
    else
      render :action => :new
    end
  end
  
  def edit
    @slide = SfSlide.find(params[:id])
  end
  
  def update
    @slide = SfSlide.find(params[:id])
    if @slide.update_attributes(params[:sf_slide])
      flash[:notice] = "Updated slide \"#{@slide.title}\""
      redirect_to :action => "index"
    else
      render :action => :edit
    end      
  end
  
  def destroy
    @slide = SfSlide.find(params[:id])
    @slide.destroy
    flash[:notice] = "Deleted slide \"#{@slide.title}\""
    redirect_to :action => "index"
  end
  
  def sort
    if params[:sf_slides]
      params[:sf_slides].each_with_index do |id, index|
        SfSlide.update_all(['position = ?', index + 1], ['id = ?', id])
      end      
    end
    render :nothing => true
  end

end
