class Admin::MediafeedSlidesController < Admin::AdminController

  def index
    @slides = MediafeedSlide.all(:order => :position)
  end
  
  def new
    @slide = MediafeedSlide.new
  end
  
  def create
    @slide = MediafeedSlide.new(params[:mediafeed_slide])
    if @slide.save
      flash[:notice] = "Created new slide \"#{@slide.title}\""
      redirect_to :action => "index"
    else
      render :action => :new
    end
  end
  
  def edit
    @slide = MediafeedSlide.find(params[:id])
  end
  
  def update
    @slide = MediafeedSlide.find(params[:id])
    if @slide.update_attributes(params[:mediafeed_slide])
      flash[:notice] = "Updated slide \"#{@slide.title}\""
      redirect_to :action => "index"
    else
      render :action => :edit
    end      
  end
  
  def destroy
    @slide = MediafeedSlide.find(params[:id])
    @slide.destroy
    flash[:notice] = "Deleted slide \"#{@slide.title}\""
    redirect_to :action => "index"
  end
  
  def sort
    if params[:mediafeed_slides]
      params[:mediafeed_slides].each_with_index do |id, index|
        MediafeedSlide.update_all(['position = ?', index + 1], ['id = ?', id])
      end      
    end
    render :nothing => true
  end

end
