class Admin::HqSlidesController < Admin::AdminController

  def index
    @slides = HqSlide.all(:order => :position)
  end
  
  def new
    @slide = HqSlide.new
  end
  
  def create
    @slide = HqSlide.new(params[:sf_slide])
    if @slide.save
      flash[:notice] = "Created new slide \"#{@slide.title}\""
      redirect_to :action => "index"
    else
      render :action => :new
    end
  end
  
  def edit
    @slide = HqSlide.find(params[:id])
  end
  
  def update
    @slide = HqSlide.find(params[:id])
    if @slide.update_attributes(params[:hq_slide])
      flash[:notice] = "Updated slide \"#{@slide.title}\""
      redirect_to :action => "index"
    else
      render :action => :edit
    end      
  end
  
  def destroy
    @slide = HqSlide.find(params[:id])
    @slide.destroy
    flash[:notice] = "Deleted slide \"#{@slide.title}\""
    redirect_to :action => "index"
  end
  
  def sort
    if params[:hq_slides]
      params[:hq_slides].each_with_index do |id, index|
        SfSlide.update_all(['position = ?', index + 1], ['id = ?', id])
      end      
    end
    render :nothing => true
  end

end
